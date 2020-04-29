//
//  CoursesViewController.swift
//  CoreDataSW
//
//  Created by Marentilo on 07.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit
import CoreData

class CoursesViewController: UITableViewController {

    private let coreDataService = CoreDataService.shared
    private let courseCell = "courseCell"
    private var courses : [Course]? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        navigationItem.title = Strings.cource
        tableView.register(CoursesTableViewCell.self, forCellReuseIdentifier: courseCell)
        loadCources()
        
        let addButton = Button.newButton(withTitle: nil, andImage: EditImages.add, tag: Int.max)
        addButton.addTarget(self, action: #selector(addButtonPressed(sender :)), for: .touchDown)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addButton)
    }
    
    private func loadCources() {
        courses = coreDataService.allCources()
    }
}

// MARK: - Actions -
extension CoursesViewController {
    @objc func addButtonPressed (sender: UIButton) {
        let vc = CoursesEditorViewController(course: nil, saveChanges: { [weak self] (course) in
            guard let self = self else { fatalError() }
            self.coreDataService.saveContext()
            self.loadCources()
        })
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UICollectionViewDataSource -
extension CoursesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let course = self.courses else {
            fatalError()
        }
        return course.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let course = courses else {
            fatalError()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: courseCell, for: indexPath) as! CoursesTableViewCell
        cell.setupView(course: course[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate -
extension CoursesViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let courcesList = courses {
            let vc = CoursesEditorViewController(course: courcesList[indexPath.row], saveChanges: { [weak self] (course) in
                guard let self = self else { fatalError() }
                self.coreDataService.saveContext()
                self.loadCources()
            })
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row > 0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let allCourses = courses else { fatalError() }
            let course = allCourses[indexPath.row]
            coreDataService.deleteObject(object: course)
            courses?.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
