//
//  AppDelegate.swift
//  CoreDataSW
//
//  Created by Marentilo on 05.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
//        let formatter = DateFormatter()
//        formatter.calendar = Calendar.current
//        formatter.dateFormat = "DD-MMM-YYYY"
//
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Course")
//        request.fetchBatchSize = 20
//        request.fetchOffset = 30
//        request.fetchLimit = 10
//        request.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true),
//                                   NSSortDescriptor(key: "firstName", ascending: true)]
        
//        let date = Date(timeIntervalSince1970: 24*3600*10)
//        let names = ["Aaron", "Mark", "Jack", "Carl"]
//        request.predicate = NSPredicate(format: "firstName < %@ && courses.@count >= %d", "W", 1)
//        request.predicate = NSPredicate(format: "lastName < %@ && firstName IN %@", "W", names)
//          request.predicate = NSPredicate(format: "students.@count == %d", 2)
//        request.predicate = NSPredicate(format: "SUBQUERY(students, $student, $student.firstName = %@).@count >= %d", "Mark", 1)
        
        return true
    }
    
    func randomStudent () -> Student {
        let student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: CoreDataService.shared.persistentContainer.viewContext) as! Student
        student.firstName = AppDelegate.arrayOfNames.randomElement()!
        student.lastName = AppDelegate.arrayOfLastNames.randomElement()!
        return student
    }
    
    func randomCourse () {
        let course = NSEntityDescription.insertNewObject(forEntityName: "Course", into: CoreDataService.shared.persistentContainer.viewContext) as! Course
//        course.numberOfHours = Double.random(in: 20...40)
        course.theme = AppDelegate.sciense.randomElement()!
        for _ in 0...Int.random(in: 1...6) {
            course.addToStudents(randomStudent())
        }
    }
    
    static let sciense = ["Art" , "Geography", "English", "Literacy", "Music", "Science", "Arithmetic", "Mathematics (Maths)", "Chemistry", "Biology", "Physics", "Drama", "Swimming", "Physical Education (P.E)", "Information Technology", "Citizenship"]
    
    static let arrayOfNames = ["Adam", "Alex", "Aaron", "Ben", "Carl", "Dan", "David", "Edward", "Fred", "Frank", "George", "Hal", "Hank", "Ike", "John", "Jack", "Joe", "Larry", "Monte", "Matthew", "Mark", "Nathan", "Otto", "Paul", "Peter", "Roger", "Roger", "Steve", "Thomas", "Tim", "Ty", "Victor", "Walter"]
    
    static let arrayOfLastNames = ["Anderson", "Ashwoon", "Aikin", "Bateman", "Bongard", "Bowers", "Boyd", "Cannon", "Cast", "Deitz", "Dewalt", "Ebner", "Frick", "Hancock", "Haworth", "Hesch", "Hoffman", "Kassing", "Knutson", "Lawless", "Lawicki", "Mccord", "McCormack", "Miller", "Myers", "Nugent", "Ortiz", "Orwig", "Ory", "Paiser", "Pak", "Pettigrew", "Quinn", "Quizoz", "Ramachandran", "Resnick", "Sagar", "Schickowski", "Schiebel", "Sellon", "Severson", "Shaffer", "Solberg", "Soloman", "Sonderling", "Soukup", "Soulis", "Stahl", "Sweeney", "Tandy", "Trebil", "Trusela", "Trussel", "Turco", "Uddin", "Uflan", "Ulrich", "Upson", "Vader", "Vail", "Valente", "Van Zandt", "Vanderpoel", "Ventotla"]

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CoreDataSW")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

