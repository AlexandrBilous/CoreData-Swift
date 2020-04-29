//
//  CoursesEditorViewController.swift
//  CoreDataSW
//
//  Created by Marentilo on 23.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit
import CoreData

final class CoursesEditorViewController : UIViewController {
    
    private let iconView = UIImageView(image: #imageLiteral(resourceName: "course"))
    private let courseTextField = TextField.createField(withName: nil, and: Strings.enterCourse, tag: 0)
    private let teacherTextField = TextField.createField(withName: nil, and: Strings.enterTeacher, tag: 0)
    private let tableView = UITableView()
    private let coreDataService : CoreDataService
    private let studentCell = "studentCell"
    private let editCell = "editCell"
    
    private var course : Course!
    private var students : [Student]?
    private let saveChanges : (Course) -> ()
    
    init(course : Course? = nil, saveChanges: @escaping (Course) -> (), coreDataService : CoreDataService = CoreDataService.shared) {
        self.coreDataService = coreDataService
        self.course = course
        self.saveChanges = saveChanges
        super.init(nibName: nil, bundle: nil)
        self.course = self.course ?? Course(entity: Course.entity(), insertInto: coreDataService.persistentContainer.viewContext)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: studentCell)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: editCell)
        teacherTextField.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Strings.save,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(saveButtonPressed(sender:)))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Strings.cancel,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(cancelButtonPressed(sender:)))
        configureTextFields()
        getStudents()
        setupConstrains()
    }
    
    private func configureTextFields() {
        if let theme = course?.theme {
            courseTextField.text = theme
        }
        if let teacherFullName = (course.teachers?.allObjects.first as? Teacher)?.fullName {
            teacherTextField.text = teacherFullName
        }
    }
    
    private func getStudents() {
        if let studentsList = course.students?.allObjects as? [Student] {
           students = studentsList
        }
    }
    
    private func setupConstrains() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        [iconView, courseTextField, teacherTextField, tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constrains = [
        iconView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    
        courseTextField.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 20),
        courseTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        courseTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    
        teacherTextField.topAnchor.constraint(equalTo: courseTextField.bottomAnchor, constant: 20),
        teacherTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        teacherTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        
        tableView.topAnchor.constraint(equalTo: teacherTextField.bottomAnchor, constant: 20),
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(constrains)
    }
}

// MARK: - Actions -
extension CoursesEditorViewController {
    @objc func saveButtonPressed(sender: UIButton) {
        course.theme = courseTextField.text
        saveChanges(course)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelButtonPressed(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension CoursesEditorViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let currentObject = course else {
            fatalError()
        }
        let vc = ManagedObjectViewController(managedObject: ManagedObject.teachers, currentObject: currentObject) { [weak self] (objects) in
            guard let self = self else { fatalError() }
            self.course.teachers = NSSet(array: objects)
            self.teacherTextField.text = (objects.first as! Teacher).fullName ?? "nil"
            self.coreDataService.saveContext()
        }
        let nc = UINavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .popover
        present(nc, animated: true, completion: nil)
        return false
    }
}

// MARK: - UITableViewDataSource -
extension CoursesEditorViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (students?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: studentCell), let studentsList = students else {
            fatalError()
        }
        if indexPath.row == 0 {
            let itemCell = tableView.dequeueReusableCell(withIdentifier: editCell)
            itemCell?.imageView?.image = EditImages.edit
            itemCell?.textLabel?.text = Strings.editStudents
            return itemCell!
        } else {
            if let name = studentsList[indexPath.row - 1].firstName, let lastName = studentsList[indexPath.row - 1].lastName {
                cell.textLabel?.text = "\(lastName) \(name)"
                cell.imageView?.image = studentsList[indexPath.row - 1].gender == 0 ? ContentImages.male : ContentImages.female
                cell.accessoryType = .detailButton
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Strings.studentsList
    }
    
}

// MARK: - UITableViewDelegate -
extension CoursesEditorViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            guard let currentObject = course else {
                fatalError()
            }
            let vc = ManagedObjectViewController(managedObject: ManagedObject.students, currentObject: currentObject) { [weak self] (objects) in
                guard let self = self, let studentsList = objects as? [Student] else {
                    fatalError()
                }
                self.course.students = NSSet(array: objects)
                self.coreDataService.saveContext()
                self.students = studentsList
                self.tableView.reloadData()
            }
            let nc = UINavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .popover
            present(nc, animated: true, completion: nil)
        } else {
            guard let studentsList = students else {
                fatalError()
            }
            let index = indexPath.row - 1
            let vc = StudentEditorViewContoller(student: studentsList[index], block: { [weak self] (student) in
                self?.coreDataService.saveContext()
                self?.tableView.reloadData()
            })
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
