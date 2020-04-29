//
//  TeacherTableViewCell.swift
//  CoreDataSW
//
//  Created by Marentilo on 23.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class TeacherTableViewCell : UITableViewCell {
    
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
        imageView?.image = nil
    }
    
    func setupTeacher (teacher: Teacher) {
        textLabel?.text = teacher.fullName ?? "nil"
        detailTextLabel?.text = "\(Strings.cources) \(teacher.courses?.count ?? 0)"
        imageView?.image = ContentImages.teacher
        accessoryType = .detailButton
    }
}
