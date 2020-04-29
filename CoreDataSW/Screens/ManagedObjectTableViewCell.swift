//
//  ManagedObjectTableViewCell.swift
//  CoreDataSW
//
//  Created by Marentilo on 29.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit
import CoreData

final class ManagedObjectTableViewCell : UITableViewCell {
    var isPressed : Bool = false
    
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
        accessoryView = nil
        imageView?.image = nil
        isPressed = false
    }
    
    func setupView (object : NSManagedObject, isSelected: Bool? = nil) {
        var image : UIImage? = UIImage()
        if let managedObject = object as? Student, let name = managedObject.firstName, let lastName = managedObject.lastName {
            textLabel?.text = "\(name) \(lastName)"
            image = managedObject.gender == 0 ? ContentImages.male : ContentImages.female
        }
        if let managedObject = object as? Teacher, let fullName = managedObject.fullName {
            textLabel?.text = fullName
            image = managedObject.gender == 0 ? ContentImages.male : ContentImages.female
        }
        
        if let managedObject = object as? Course, let topic = managedObject.theme {
            textLabel?.text = topic
            image = BarImages.course
        }
        
        if let isSelect = isSelected {
            isPressed = isSelect
            accessoryView = UIImageView(image: isPressed ? EditImages.bookmark_pressed : EditImages.bookmark)
        }
        imageView?.image = image
    }
    
}
