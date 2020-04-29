//
//  CoreDataService.swift
//  CoreDataSW
//
//  Created by Marentilo on 28.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataService {
    
    static let shared = CoreDataService()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataSW")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    /// empty construct
    private init() {}
    
    /// save changes in current context
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /// arrays of students
    func allStudents() -> [Student]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        do {
            let students = try persistentContainer.viewContext.fetch(request) as? [Student]
            return students
        } catch {
            print("Failed to fetch employees: \(error)")
        }
        return []
    }
    
    /// students for specific cources list
    func studentsForCources(cources: [Course]) -> [Student]? {
        let coursesName = cources.map({ $0.theme })
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Course")
        request.predicate = NSPredicate(format: "theme in %@", coursesName)
        do {
            let allCourses = try persistentContainer.viewContext.fetch(request) as! [Course]
             return allCourses.map({ $0.students?.allObjects as! [Student] }).reduce([], +)
         } catch {
             print(error.localizedDescription)
         }
        return []
    }
    
    /// arrays of cources
    func allCources() -> [Course]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Course")
        do {
            let courses = try persistentContainer.viewContext.fetch(request) as? [Course]
            return courses
        } catch {
            print("Failed to fetch employees: \(error)")
        }
        return []
    }
    
    /// arrays of teachers
    func allTeachers() -> [Teacher]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Teacher")
        do {
            let teachers = try persistentContainer.viewContext.fetch(request) as? [Teacher]
            return teachers
        } catch {
            print("Failed to fetch employees: \(error)")
        }
        return []
    }
    
    /// arrays of teachers for some Course
    func allTeachersForCouse(course: Course) -> [Teacher] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Teacher")
        request.predicate = NSPredicate(format: "courses contains %@", course)
        do {
            let teachers = try persistentContainer.viewContext.fetch(request) as! [Teacher]
            return teachers
        } catch {
            print("Failed to fetch employees: \(error)")
        }
        return []
    }
    
    
    func deleteObject(object : NSManagedObject) {
        persistentContainer.viewContext.delete(object)
        saveContext()
    }
}
