//
//  CreateCompanyController.swift
//  Companies
//
//  Created by Dmitriy Chernov on 24.01.2021.
//

import UIKit

class CreateCompanyController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create Company"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        view.backgroundColor = UIColor.blueColor
        
        // Do any additional setup after loading the view.
    }
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
