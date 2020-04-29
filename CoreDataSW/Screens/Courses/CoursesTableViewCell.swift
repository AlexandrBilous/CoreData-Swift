//
//  CoursesTableViewCell.swift
//  CoreDataSW
//
//  Created by Marentilo on 25.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

class CoursesTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
        detailTextLabel?.text = nil
    }
    
    func setupView(course : Course) {
        textLabel?.text = course.theme
        accessoryType = .disclosureIndicator
        detailTextLabel?.text = (course.teachers?.allObjects as! [Teacher]).first?.fullName ?? "nil"
    }
    
}
