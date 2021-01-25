//
//  ViewController.swift
//  Companies
//
//  Created by Dmitriy Chernov on 07.10.2020.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
        var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCompanies()
        view.backgroundColor = .white
        
        navigationItem.title = "Companies"
        setUpTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
//        setupNavigationStyle()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, editing) in
            let editCompanyController = CreateCompanyController()
            editCompanyController.delegate = self
            editCompanyController.company = self.companies[indexPath.row]
            let navController = CustomNavigationController(rootViewController: editCompanyController)
            self.present(navController, animated: true)
        }

        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            tableView.isEditing = true
            let context = CoreDataManager.shared.persistentContainer.viewContext
            context.delete(self.companies[indexPath.row])
            self.companies.remove(at: indexPath.row)
            do {
                try context.save()
            } catch let err {
                print("Failed to delete company:", err)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        edit.backgroundColor = UIColor.blueColor    
        let config = UISwipeActionsConfiguration(actions: [delete, edit])
        return config
    }
    
    private func editHandlerFunction(action: UIContextualAction, view: UIView, bool: (Bool) -> (Void)) {
        print("editing company in separate function")
        
      
    }
    
    private func fetchCompanies() {
        let context = CoreDataManager.shared.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do {
            let companies = try context.fetch(fetchRequest)
            
            self.companies = companies
            self.tableView.reloadData()
            
        } catch let error {
            print("Failed to fetch companies:", error)
        }
    }
    
    @objc func handleAddCompany() {
        print("Adding company...")
        
        let createCompanyController = CreateCompanyController()
        
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        createCompanyController.delegate = self
        present(navController, animated: true)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let company = companies[indexPath.row]
        cell.backgroundColor = .tealColor
        if let name = company.name, let founded = company.founded {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let foundedDateString = dateFormatter.string(from: founded)
            let textString = "\(name) - Founded: \(foundedDateString)"
            cell.textLabel?.text = textString
        } else {
            cell.textLabel?.text = company.name
        }
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    
        if let imageData = company.imageData {
            cell.imageView?.image = UIImage(data: imageData)
        } else {
            cell.imageView?.image = #imageLiteral(resourceName: "select_photo_empty")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func setUpTableView() {
        tableView.backgroundColor = .blueColor
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }
}

extension CompaniesController: CreateCompanyControllerDelegate {
    func didAddCompany(company: Company) {
        // 1 - modify your array
        companies.append(company)
        // 2 - insert a new indexpath into tableVIew
        tableView.insertRows(at: [IndexPath(row: companies.count - 1, section: 0)], with: .automatic)
    }
    
    func didEditCompany(company: Company) {
        let row = companies.firstIndex(of: company)
        
        guard let forceRow = row else { return }
        let reloadIndexPath = IndexPath(row: forceRow, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
}

