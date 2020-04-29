//
//  Teacher+CoreDataProperties.swift
//  CoreDataSW
//
//  Created by Marentilo on 24.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//
//

import Foundation
import CoreData


extension Teacher {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Teacher> {
        return NSFetchRequest<Teacher>(entityName: "Teacher")
    }

    @NSManaged public var email: String?
    @NSManaged public var fullName: String?
    @NSManaged public var gender: Int64
    @NSManaged public var courses: NSSet?
    @NSManaged public var university: University?

}

// MARK: Generated accessors for courses
extension Teacher {

    @objc(addCoursesObject:)
    @NSManaged public func addToCourses(_ value: Course)

    @objc(removeCoursesObject:)
    @NSManaged public func removeFromCourses(_ value: Course)

    @objc(addCourses:)
    @NSManaged public func addToCourses(_ values: NSSet)

    @objc(removeCourses:)
    @NSManaged public func removeFromCourses(_ values: NSSet)

}
