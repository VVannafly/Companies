//
//  CreateEmployeeController.swift
//  Companies
//
//  Created by Dmitriy Chernov on 26.01.2021.
//

import UIKit

protocol CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {
    
    var delegate: CreateEmployeeControllerDelegate?
    var company: Company?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        //enable autolayout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Birthday"
        //enable autolayout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "MM/dd/yyyy"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create Employee"
        setupCancelButton()
        view.backgroundColor = UIColor.blueColor
        setupUI()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    @objc private func handleSave() {
        guard let employeeName = nameTextField.text else { return }
        guard let company = self.company else { return }
        
        guard let birthdayText = birthdayTextField.text else { return }
        if birthdayText.isEmpty {
            showError(title: "Empty Birthday", message: "You have not entered a birthday.")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
            showError(title: "Bad date", message: "Birthday date not valid")
            return
        }

        let result = CoreDataManager.shared.createEmployee(employeeName: employeeName, birthday: birthdayDate, company: company)
        switch result {
        case .failure(let error):
            print(error)
        case .success(let data):
            dismiss(animated: true) {
                self.delegate?.didAddEmployee(employee: data)
            }
        }
    }
    
    private func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alertController, animated: true)
    }
    
    private func setupUI() {
        _ = setupLightBlueBackgroundView(height: 100)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(birthdayLabel)
        view.addSubview(birthdayTextField)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 50),
            nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor),
            nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            
            birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            birthdayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            birthdayLabel.widthAnchor.constraint(equalToConstant: 100),
            birthdayLabel.heightAnchor.constraint(equalToConstant: 50),
            
            birthdayTextField.topAnchor.constraint(equalTo: birthdayLabel.topAnchor),
            birthdayTextField.leftAnchor.constraint(equalTo: birthdayLabel.rightAnchor, constant: 50),
            birthdayTextField.rightAnchor.constraint(equalTo: view.rightAnchor),
            birthdayTextField.bottomAnchor.constraint(equalTo: birthdayLabel.bottomAnchor),
        ])
    }
    
    
}
