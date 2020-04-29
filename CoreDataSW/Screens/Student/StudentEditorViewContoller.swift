//
//  StudentEditorViewContoller.swift
//  CoreDataSW
//
//  Created by Marentilo on 22.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class StudentEditorViewContoller : UIViewController {
    
    private let coreDataService : CoreDataService
    private var student : Student?
    private let cources : [Course]?
    private let block : (Student) -> ()
    private let defaulfCell = "defaulfCell"
    private let imageView = UIImageView()
    private let tableView = UITableView()
    
    private lazy var genderController : UISegmentedControl = {
        let controller = UISegmentedControl(items: [Strings.male, Strings.female])
        controller.selectedSegmentIndex = 0
        controller.addTarget(self, action: #selector(genderValueChanged(sender:)), for: .valueChanged)
        return controller
    } ()
    
    private let nameTextField = TextField.createField(withName: nil, and: Strings.enterFirstName, tag: 0, delegade: nil)
    private let lastNameTextField = TextField.createField(withName: nil, and: Strings.enterLastName, tag: 0, delegade: nil)
    private let emailTextField = TextField.createField(withName: nil, and: Strings.enterEmail, tag: 0, delegade: nil)
    
    init (student : Student? = nil, block : @escaping (Student) -> (), coreDataService : CoreDataService = CoreDataService.shared) {
        self.coreDataService = coreDataService
        self.student = student
        self.cources = student?.courses?.allObjects as? [Course]
        self.block = block
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: defaulfCell)
        
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
        
        setupConstrains()
        setupCells()
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
            genderController.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spaces.double),
            genderController.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spaces.double),
            
            tableView.topAnchor.constraint(equalTo: genderController.bottomAnchor, constant: Spaces.double),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spaces.double),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spaces.double),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Spaces.double)
        ]
        
        NSLayoutConstraint.activate(constrains)
    }
    
    private func setupCells () {
        if let currrentStudent = student {
            nameTextField.text = currrentStudent.firstName ?? String()
            lastNameTextField.text = currrentStudent.lastName ?? String()
            emailTextField.text = currrentStudent.email ?? String()
            genderController.selectedSegmentIndex = Int(currrentStudent.gender)
        }
        imageView.image = genderController.selectedSegmentIndex == 1 ? #imageLiteral(resourceName: "female_big") : #imageLiteral(resourceName: "male_big")
    }
    
   private func currentTextField (index: Int) -> UITextField {
        var textField = UITextField()
        switch index {
        case 0: textField = nameTextField
        case 1: textField = lastNameTextField
        case 2: textField = emailTextField
        default:
            break
        }
        return textField
    }
}

// MARK: - Actions -
extension StudentEditorViewContoller {
    @objc func genderValueChanged(sender: UISegmentedControl) {
        imageView.image = sender.selectedSegmentIndex == 1 ? #imageLiteral(resourceName: "female_big") : #imageLiteral(resourceName: "male_big")
    }
    
    @objc func cancelButtonPressed (sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonPressed (sender: UIBarButtonItem) {
        let student = self.student ?? Student(entity: Student.entity(), insertInto: coreDataService.persistentContainer.viewContext)
        student.firstName = nameTextField.text
        student.lastName = lastNameTextField.text
        student.email = emailTextField.text
        student.gender = Int64(genderController.selectedSegmentIndex)
        block(student)
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate -
extension StudentEditorViewContoller : UITableViewDataSource {
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
            if let courcesList = cources, let theme = courcesList[indexPath.row].theme {
                cell.textLabel?.text = theme
            }
        }
        return cell
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : cources?.count ?? 0
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
        
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? Strings.studentInfo : Strings.courcesList
    }
}

// MARK: - UITableViewDelegate -
extension StudentEditorViewContoller : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
