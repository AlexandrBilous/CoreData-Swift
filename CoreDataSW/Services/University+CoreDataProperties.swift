//
//  University+CoreDataProperties.swift
//  CoreDataSW
//
//  Created by Marentilo on 29.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//
//

import Foundation
import CoreData


extension University {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<University> {
        return NSFetchRequest<University>(entityName: "University")
    }

    @NSManaged public var courses: NSSet?
    @NSManaged public var students: NSSet?
    @NSManaged public var teachers: NSSet?

}

// MARK: Generated accessors for courses
extension University {

    @objc(addCoursesObject:)
    @NSManaged public func addToCourses(_ value: Course)

    @objc(removeCoursesObject:)
    @NSManaged public func removeFromCourses(_ value: Course)

    @objc(addCourses:)
    @NSManaged public func addToCourses(_ values: NSSet)

    @objc(removeCourses:)
    @NSManaged public func removeFromCourses(_ values: NSSet)

}

// MARK: Generated accessors for students
extension University {

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
extension University {

    @objc(addTeachersObject:)
    @NSManaged public func addToTeachers(_ value: Teacher)

    @objc(removeTeachersObject:)
    @NSManaged public func removeFromTeachers(_ value: Teacher)

    @objc(addTeachers:)
    @NSManaged public func addToTeachers(_ values: NSSet)

    @objc(removeTeachers:)
    @NSManaged public func removeFromTeachers(_ values: NSSet)

}
