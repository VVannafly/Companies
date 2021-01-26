//
//  CoreDataManager.swift
//  Companies
//
//  Created by Dmitriy Chernov on 24.01.2021.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    public init() { }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Companies")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func fetchCompanies() -> [Company] {
        let context = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
        } catch let error {
            print("Failed to fetch companies:", error)
            return []
        }
    }
    
    func createEmployee(employeeName: String, birthday: Date, company: Company) -> Result<Employee, Error> {
        let context = persistentContainer.viewContext
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        employee.setValue(employeeName, forKey: "name")
        employee.company = company
        //lets check company is setup correctly
//        let company = Company(context: context)
//        company.employees
        
        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
        employeeInformation.taxId = "456"
        employeeInformation.birthday = birthday
        employee.employeeInformation = employeeInformation
        
        do {
            try context.save()
            return Result.success(employee)
        } catch let err {
            print("Failed to create employee:", err)
            return Result.failure(err)
        }
    }
}
