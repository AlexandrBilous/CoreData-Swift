//
//  Course+CoreDataProperties.swift
//  CoreDataSW
//
//  Created by Marentilo on 07.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//
//

import Foundation
import CoreData


extension Course {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }

    @NSManaged public var theme: String?
    @NSManaged public var numberOfHours: Double
    @NSManaged public var courses: NSSet?

}

// MARK: Generated accessors for courses
extension Course {

    @objc(addCoursesObject:)
    @NSManaged public func addToCourses(_ value: Student)

    @objc(removeCoursesObject:)
    @NSManaged public func removeFromCourses(_ value: Student)

    @objc(addCourses:)
    @NSManaged public func addToCourses(_ values: NSSet)

    @objc(removeCourses:)
    @NSManaged public func removeFromCourses(_ values: NSSet)

}
