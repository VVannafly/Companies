//
//  EmployeesController.swift
//  Companies
//
//  Created by Dmitriy Chernov on 26.01.2021.
//

import UIKit
import CoreData

class EmployeesController: UITableViewController {
    
    var company: Company?
    var employees = [Employee]()
    
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath)
        let employee = employees[indexPath.row]
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
        
        self.employees = companyEmployees
        //        let context = CoreDataManager.shared.persistentContainer.viewContext
        //        let request = NSFetchRequest<Employee>(entityName: "Employee")
        //        do {
        //            let employees = try context.fetch(request)
        //            self.employees = employees
        //        } catch let err {
        //            print("Failed to fetch employees:", err)
        //        }
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
        employees.append(employee)
        tableView.reloadData()
    }
}
