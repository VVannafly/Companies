//
//  CompaniesController+CreateCompany.swift
//  Companies
//
//  Created by Dmitriy Chernov on 26.01.2021.
//

import UIKit

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
