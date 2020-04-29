//
//  Student+CoreDataProperties.swift
//  CoreDataSW
//
//  Created by Marentilo on 05.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?

}
