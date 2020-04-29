//
//  UniversityViewController.swift
//  CoreDataSW
//
//  Created by Marentilo on 21.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit
import CoreData

final class TeachersViewController : UITableViewController {
    
    private let coreDataService = CoreDataService.shared
    private let teacherCell = "teacherCell"
    
    private var allTeachers : [Teacher]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var courses : [String] = []
    private var coursesList : [String : [Teacher]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Strings.add,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addButtonPressed(sender:)))
        tableView.register(TeacherTableViewCell.self, forCellReuseIdentifier: teacherCell)
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        tableView.reloadData()
    }
    
    private func loadData () {
        allTeachers = coreDataService.allTeachers()
        if let coursesList = coreDataService.allCources() {
            courses = coursesList.compactMap { course -> String in
               let courseName = course.theme ?? "nil"
                self.coursesList.updateValue(coreDataService.allTeachersForCouse(course: course), forKey: courseName)
                return courseName
            }
        }
    }
}

// MARK: - Actions
extension TeachersViewController {
    @objc func addButtonPressed (sender: UIBarButtonItem) {
        let vc = TeacherEditorViewController() { [weak self] (student) in
            self?.coreDataService.saveContext()
            self?.loadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TeachersViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return courses.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let teacher = coursesList[courses[section]] {
            return teacher.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let coursesList = coreDataService.allCources() else { fatalError() }
        return coursesList[section].theme ?? "Nil"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: teacherCell) as? TeacherTableViewCell,
            let teachersForSection = coursesList[courses[indexPath.section]] else {
                fatalError()
        }
        let teacher = teachersForSection[indexPath.row]
        cell.setupTeacher(teacher: teacher)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TeachersViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let teachersList = coursesList[courses[indexPath.section]] else {
            fatalError()
        }
        
        let vc = TeacherEditorViewController(teacher: teachersList[indexPath.row]) { [weak self] (student) in
            self?.coreDataService.saveContext()
            self?.loadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let teachersList = coursesList[courses[indexPath.section]] else { fatalError() }
        coreDataService.deleteObject(object: teachersList[indexPath.row])
        loadData()
        tableView.reloadData()
    }
}
