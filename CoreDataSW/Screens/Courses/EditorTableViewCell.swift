//
//  EditorTableViewCell.swift
//  CoreDataSW
//
//  Created by Marentilo on 23.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class EditorTableViewCell : UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
        detailTextLabel?.text = nil
        accessoryView = nil
    }
    
    func setupCourse (course : Course) {
        textLabel?.text
    }
}
