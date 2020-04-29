//
//  TeacherEditorViewController.swift
//  CoreDataSW
//
//  Created by Marentilo on 23.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit
import CoreData

final class TeacherEditorViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var teacher : Teacher?
    private var cources : [Course]?
    private var students : [Student]?
    private let block : (Teacher) -> ()
    private let defaulfCell = "defaulfCell"
    private let studentandCoursesCell = "studentandCoursesCell"
    private let coreDataService = CoreDataService.shared
    
    private let imageView = UIImageView()
    private let tableView = UITableView()
    
    private lazy var genderController : UISegmentedControl = {
        let controller = UISegmentedControl(items: [Strings.male, Strings.female])
        controller.selectedSegmentIndex = 0
        controller.addTarget(self, action: #selector(genderChanged(sender:)), for: .valueChanged)
        return controller
    } ()
    
    private let fullnameTextField = TextField.createField(withName: nil, and: Strings.enterFullName , tag: 0, delegade: nil)
    private let emailTextField = TextField.createField(withName: nil, and: Strings.enterEmail, tag: 0, delegade: nil)
    
    init (teacher : Teacher? = nil, block : @escaping (Teacher) -> ()) {
        self.teacher = teacher
        self.block = block
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        imageView.image = ContentImages.female_big
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Strings.save,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(saveButtonPressed(sender:)))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Strings.cancel,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(cancelButtonPressed(sender:)))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: defaulfCell)
        tableView.register(ManagedObjectTableViewCell.self, forCellReuseIdentifier: studentandCoursesCell)
        
        setupConstrains()
        loadCourses()
        loadStudents()
        setupCells()
    }
    
    private func loadStudents () {
        if let coursesList = teacher?.courses?.allObjects as? [Course] {
            students = coreDataService.studentsForCources(cources: coursesList)
        }
    }
    
    private func loadCourses () {
        if let coursesList = teacher?.courses?.allObjects as? [Course] {
            cources = coursesList
        }
    }
    
    private func setupConstrains() {
        [imageView, genderController, tableView].forEach {
               view.addSubview($0)
               $0.translatesAutoresizingMaskIntoConstraints = false
           }
           
        let constrains = [
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Spaces.double),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            genderController.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Spaces.double),
            genderController.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: genderController.bottomAnchor, constant: Spaces.double),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spaces.double),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spaces.double),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Spaces.double)
        ]
           
        NSLayoutConstraint.activate(constrains)
    }
    
    private func setupCells () {
        if let currentTeacher = teacher {
            fullnameTextField.text = currentTeacher.fullName ?? String()
            emailTextField.text = currentTeacher.email ?? String()
            genderController.selectedSegmentIndex = Int(currentTeacher.gender)
        }
        imageView.image = genderController.selectedSegmentIndex == 1 ? #imageLiteral(resourceName: "female_big") : #imageLiteral(resourceName: "male_big")
    }
    
    private func currentTextField (index: Int) -> UITextField {
        var textField = UITextField()
        switch index {
        case 0: textField = fullnameTextField
        case 1: textField = emailTextField
        default:
            break
        }
        return textField
    }
}

// MARK: - UITableViewDataSource -
extension TeacherEditorViewController {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: defaulfCell) else {
            fatalError()
        }
        if indexPath.section == 0 {
        let textField = currentTextField(index: indexPath.row)
        cell.contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints                                                      = false
        textField.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10).isActive               = true
        textField.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10).isActive        = true
        textField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20).isActive       = true
        textField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20).isActive    = true
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: studentandCoursesCell) as? ManagedObjectTableViewCell, let coursesList = cources, let studentList = students  else {
                fatalError()
            }
            cell.setupView(object: indexPath.section == 1 ? coursesList[indexPath.row] : studentList[indexPath.row])
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return cources?.count ?? 0
        default: return students?.count ?? 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let result : String
        switch section {
        case 0:
            result = Strings.teacherInfo
        case 1:
            result = Strings.courcesList
        default:
            result = Strings.studentsList
        }
        return result
    }
}

// MARK: - UITableViewDelegate -
extension TeacherEditorViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Actions -
extension TeacherEditorViewController {
    @objc func genderChanged (sender: UISegmentedControl) {
        imageView.image = sender.selectedSegmentIndex == 1 ? #imageLiteral(resourceName: "female_big") : #imageLiteral(resourceName: "male_big")
    }
    
    @objc func cancelButtonPressed (sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonPressed (sender: UIBarButtonItem) {
        let teacher : Teacher
        if let item = self.teacher {
            teacher = item
        } else {
            teacher = Teacher(entity: Teacher.entity(), insertInto: coreDataService.persistentContainer.viewContext)
        }
        
        teacher.fullName = fullnameTextField.text
        teacher.email = emailTextField.text
        teacher.gender = Int64(genderController.selectedSegmentIndex)
        block(teacher)
        self.navigationController?.popViewController(animated: true)
    }
}
