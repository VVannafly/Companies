//
//  Service.swift
//  Companies
//
//  Created by Dmitriy Chernov on 28.01.2021.
//

import UIKit
import CoreData

struct Service {
    
    static let shared = Service()
    
    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func downloadCompaniesFromServer() {
        print("Attempting to download companies...")
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            print("Finished downloading")
            if let error = error {
                print("Failed to download companies:", error)
                return
            }
            
            guard let data = data else { return }
            //            let string = String(data: data, encoding: .utf8)
            let jsonDecoder = JSONDecoder()
            do {
                let jsonCompaines = try
                    jsonDecoder.decode([JSONCompany].self, from: data)
                let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
                jsonCompaines.forEach { (jsonCompany) in
                    print(jsonCompany.name)
                    let company = Company(context: privateContext)
                    company.name = jsonCompany.name
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    let foundedDate = dateFormatter.date(from: jsonCompany.founded)
                     company.founded = foundedDate
                   
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        print(" \(jsonEmployee.name)")
                        let employee = Employee(context: privateContext)
                        employee.name = jsonEmployee.name
                        employee.type = jsonEmployee.type
                        
                        let employeeInformation = EmployeeInformation(context: privateContext)
                        let birthdayDate = dateFormatter.date(from: jsonEmployee.birthday)
                        employee.employeeInformation?.birthday = birthdayDate
                        employee.employeeInformation = employeeInformation
                        
                        employee.company = company
                    })
                    
                    do {
                        try privateContext.save()
                        try privateContext.parent?.save()
                    } catch let saveErr {
                        print("Failed to save companies:", saveErr)
                    }
                }
            } catch let jsonDecoderError {
                print("Failed to decode:", jsonDecoderError)
            }
            
        }.resume() // do not forget this call
    }
    
    
}

struct JSONCompany: Codable {
    let name: String
    let founded: String
    var employees: [JSONEmployee]?
    let photoUrl: String
}

struct JSONEmployee: Codable {
    let name: String
    let birthday: String
    let type: String
}
