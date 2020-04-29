//
//  Course+CoreDataProperties.swift
//  CoreDataSW
//
//  Created by Marentilo on 29.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//
//

import Foundation
import CoreData


extension Course {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }

    @NSManaged public var specialisation: String?
    @NSManaged public var theme: String?
    @NSManaged public var students: NSSet?
    @NSManaged public var teachers: NSSet?
    @NSManaged public var university: University?

}

// MARK: Generated accessors for students
extension Course {

    @objc(addStudentsObject:)
    @NSManaged public func addToStudents(_ value: Student)

    @objc(removeStudentsObject:)
    @NSManaged public func removeFromStudents(_ value: Student)

    @objc(addStudents:)
    @NSManaged public func addToStudents(_ values: NSSet)

    @objc(removeStudents:)
    @NSManaged public func removeFromStudents(_ values: NSSet)

}

// MARK: Generated accessors for teachers
extension Course {

    @objc(addTeachersObject:)
    @NSManaged public func addToTeachers(_ value: Teacher)

    @objc(removeTeachersObject:)
    @NSManaged public func removeFromTeachers(_ value: Teacher)

    @objc(addTeachers:)
    @NSManaged public func addToTeachers(_ values: NSSet)

    @objc(removeTeachers:)
    @NSManaged public func removeFromTeachers(_ values: NSSet)

}
