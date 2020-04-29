//
//  StudendCell.swift
//  CoreDataSW
//
//  Created by Marentilo on 05.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

class StudendCell: UITableViewCell {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    private let nameLabel = Label.makeLabel()
    private let lastName = Label.makeLabel()
    private let dayOfBirthLabel = Label.makeLabel()

    
    var nameTitle : String? {
        get {return nameLabel.text}
        set {nameLabel.text = newValue}
    }
    
    var lastNameTitle : String? {
        get {return lastName.text}
        set {lastName.text = newValue}
    }
    
    var birthTitle : String? {
        get {return dayOfBirthLabel.text}
        set {dayOfBirthLabel.text = newValue}
    }
    
    func setupView() {
    
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.backgroundColor = UIColor.yellow
        
        [
            nameLabel,
            lastName,
            dayOfBirthLabel
        ].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        })
        
        setupConstrains()
    }
    
    func setupConstrains() {
        let constrains = [
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spaces.single),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spaces.double),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spaces.double),
            
            lastName.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Spaces.single),
            lastName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spaces.double),
            lastName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spaces.double),
            
            dayOfBirthLabel.topAnchor.constraint(equalTo: lastName.bottomAnchor, constant: Spaces.single),
            dayOfBirthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spaces.double),
            dayOfBirthLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spaces.double),
            dayOfBirthLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spaces.single)
        ]
        
        NSLayoutConstraint.activate(constrains)
    }
}
