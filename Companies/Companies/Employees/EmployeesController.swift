//
//  EmployeesController.swift
//  Companies
//
//  Created by Dmitriy Chernov on 26.01.2021.
//

import UIKit
import CoreData

class IndentedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = rect.inset(by: insets)
        super.drawText(in: customRect)
    }
}

class EmployeesController: UITableViewController {
    
    var company: Company?
//    var employees = [Employee]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.blueColor
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EmployeeCell")
        fetchEmployees()
    }
    
    var allEmployees = [[Employee]]()
    var employeeTypes = [
        EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagement.rawValue,
        EmployeeType.Staff.rawValue
    ]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        label.text = employeeTypes[section]
        label.textColor = UIColor.blueColor
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = UIColor.lightBlue
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath)
        
        let employee = allEmployees[indexPath.section][indexPath.row]
//        let employee = employees[indexPath.row]
        cell.textLabel?.text = employee.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        if let birthday = employee.employeeInformation?.birthday {
            cell.textLabel?.text = "\(employee.name ?? "")     \(dateFormatter.string(from: birthday))"
        }
        
        cell.backgroundColor = UIColor.tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return cell
    }
    
    private func fetchEmployees() {
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
        allEmployees = []
        employeeTypes.forEach { employeeType in
            allEmployees.append(companyEmployees.filter{$0.type == employeeType})
        }
    }
    
    @objc private func handleAdd() {
        print("Trying to add an employee...")
        
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        let navController = UINavigationController(rootViewController: createEmployeeController)
        present(navController, animated: true)
    }
}

extension EmployeesController: CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee) {
        guard let section = employeeTypes.firstIndex(of: employee.type!) else { return }
        let row = allEmployees[section].count
        let insertionIndexPath = IndexPath(row: row, section: section)
        allEmployees[section].append(employee)
        tableView.insertRows(at: [insertionIndexPath], with: .middle)
    }
}
