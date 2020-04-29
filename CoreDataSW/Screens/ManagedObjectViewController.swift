//
//  ManagedObjectViewController.swift
//  CoreDataSW
//
//  Created by Marentilo on 29.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit
import CoreData

enum ManagedObject {
    case teachers
    case students
}

final class ManagedObjectViewController : UITableViewController {
    private let managedObject : ManagedObject
    private let currentObject : NSManagedObject
    private let saveChanges : ([NSManagedObject]) -> ()
    private var allManagedObjects : [NSManagedObject] = Array()
    private var selectedManagedObjects : [NSManagedObject] = Array()
    
    private let coreDataService = CoreDataService.shared
    private let objectCell = "ObjectCell"
    
    init (managedObject : ManagedObject, currentObject : NSManagedObject, saveChanges: @escaping ([NSManagedObject]) -> ()) {
        self.managedObject = managedObject
        self.currentObject = currentObject
        self.saveChanges = saveChanges
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ManagedObjectTableViewCell.self, forCellReuseIdentifier: objectCell)
        switch managedObject {
        case .students:
            loadStudents()
        case .teachers:
            loadTeachers()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Strings.save,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(saveButtonPressed(sender:)))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Strings.cancel,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(cancelButtonPressed(sender:)))
    }
    
    private func loadStudents() {
        selectedManagedObjects = (currentObject as! Course).students?.allObjects as! [NSManagedObject]
        allManagedObjects = coreDataService.allStudents() ?? []
    }
    
    private func loadTeachers() {
        selectedManagedObjects = (currentObject as! Course).teachers?.allObjects as! [NSManagedObject]
        allManagedObjects = coreDataService.allTeachers() ?? []
    }
    
    private func constainsObject (_ managedObject : NSManagedObject) -> Bool {
        return selectedManagedObjects.contains(managedObject)
    }
}

// MARK: - Actions -
extension ManagedObjectViewController {
    @objc func saveButtonPressed(sender : UIBarButtonItem) {
        saveChanges(selectedManagedObjects)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelButtonPressed(sender : UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate -
extension ManagedObjectViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? ManagedObjectTableViewCell else {
            fatalError()
        }

        if cell.isPressed, let firstIndex = selectedManagedObjects.firstIndex(of: allManagedObjects[indexPath.row])  {
            selectedManagedObjects.remove(at: firstIndex)
        } else {
            selectedManagedObjects.append(allManagedObjects[indexPath.row])
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - UITableViewDataSource -
extension ManagedObjectViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allManagedObjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: objectCell) as? ManagedObjectTableViewCell else {
            fatalError()
        }
        let source = allManagedObjects[indexPath.row]
        cell.setupView(object: source, isSelected: constainsObject(source))
        return cell
    }
}
