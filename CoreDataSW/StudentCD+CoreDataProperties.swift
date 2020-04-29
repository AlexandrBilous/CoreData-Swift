//
//  StudentCD+CoreDataProperties.swift
//  CoreDataSW
//
//  Created by Marentilo on 05.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//
//

import Foundation
import CoreData


extension StudentCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudentCD> {
        return NSFetchRequest<StudentCD>(entityName: "Student")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var dateOfBirrth: Date?

}
