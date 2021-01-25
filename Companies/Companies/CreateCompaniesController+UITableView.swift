//
//  CreateCompaniesController+UITableView.swift
//  Companies
//
//  Created by Dmitriy Chernov on 26.01.2021.
//

import UIKit

extension CompaniesController {
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No companies available..."
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count == 0 ? 150 : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CompanyCell
        let company = companies[indexPath.row]
        cell.company = company
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
}
