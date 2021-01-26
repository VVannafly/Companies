//
//  UIViewController+Helpers.swift
//  Companies
//
//  Created by Dmitriy Chernov on 26.01.2021.
//

import UIKit

extension UIViewController {
    
    func setupPlusButtonInNavBar(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: selector)
    }
    
    func setupCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelModal))
    }
    
    @objc func handleCancelModal() {
        dismiss(animated: true)
    }
    
    func setupLightBlueBackgroundView(height: CGFloat) -> UIView {
        let lightBlueBackgroundView = UIView()
        lightBlueBackgroundView.backgroundColor = UIColor.lightBlue
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lightBlueBackgroundView)
        
        NSLayoutConstraint.activate([
            lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: height),
        ])
        
        return lightBlueBackgroundView
    }
    
    
}
