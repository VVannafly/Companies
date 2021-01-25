//
//  CompanyCell.swift
//  Companies
//
//  Created by Dmitriy Chernov on 25.01.2021.
//

import UIKit

class CompanyCell: UITableViewCell {
    
    var company: Company? {
        didSet {
            nameFoundedDateLabel.text = company?.name
            
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
            }
            
            if let name = company?.name, let founded = company?.founded {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                let foundedDateString = dateFormatter.string(from: founded)
                let textString = "\(name) - Founded: \(foundedDateString)"
                nameFoundedDateLabel.text = textString
            } else {
                nameFoundedDateLabel.text = company?.name
            }
        }
    }
    
    let companyImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.blueColor.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    let nameFoundedDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Company Name"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.tealColor
        
        addSubview(companyImageView)
        addSubview(nameFoundedDateLabel)
        
        NSLayoutConstraint.activate([
            companyImageView.heightAnchor.constraint(equalToConstant: 40),
            companyImageView.widthAnchor.constraint(equalToConstant: 40),
            companyImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            nameFoundedDateLabel.leftAnchor.constraint(equalTo: companyImageView.rightAnchor, constant: 8),
            nameFoundedDateLabel.topAnchor.constraint(equalTo: topAnchor),
            nameFoundedDateLabel.rightAnchor.constraint(equalTo: rightAnchor),
            nameFoundedDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
