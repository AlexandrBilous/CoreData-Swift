//
//  RootTabBarViewController.swift
//  CoreDataSW
//
//  Created by Marentilo on 06.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

class RootTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                
        let student = StudentViewController()
        student.tabBarItem = UITabBarItem(title: Strings.students,
                                          image: BarImages.student,
                                          tag: 0)
        
        let courses = CoursesViewController()
        courses.tabBarItem = UITabBarItem(title: "Courses",
                                          image: BarImages.course,
                                          tag: 1)
        
        let university = TeachersViewController()
        university.tabBarItem = UITabBarItem(title: Strings.teachers,
                                             image: BarImages.university,
                                             tag: 2)
        
        let defaultControllers : [UIViewController] = [student, courses, university]
        let navControllers = defaultControllers.map { UINavigationController(rootViewController: $0) }
        
        setViewControllers(navControllers, animated: false)
    }

}
