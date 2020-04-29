//
//  ViewController.swift
//  CoreDataSW
//
//  Created by Marentilo on 05.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit
import CoreData

class StudentViewController: UITableViewController {
    
    private let coreDataService = CoreDataService.shared
    private var students : [Student]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var addButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        return button
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "id")
        tableView.backgroundColor = UIColor.white

        addButton.addTarget(self, action: #selector(addButtonPressed(_ :)), for: .touchDown)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addButton)
        
        loadStudents()
    }
    
    private func loadStudents() {
       students = coreDataService.allStudents()
    }
    
    private func setupCell (cell : UITableViewCell, withSource source : Student) {
        guard let name = source.firstName, let lastName = source.lastName else {
            fatalError()
        }
        cell.textLabel?.text = "\(lastName) \(name)"
        cell.accessoryType = .detailButton
    }
    
    private let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "dd-MMM-YYYY"
        return formatter
    } ()
}

// MARK: - Actions -
extension StudentViewController {
    @objc func addButtonPressed (_ sender: UIButton) {
        let vc = StudentEditorViewContoller(student: nil, block: { [weak self] (student) in
            self?.coreDataService.saveContext()
            self?.loadStudents()
        })
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UITableViewDataSource -
extension StudentViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let object = students else {
            fatalError()
        }
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = StudentEditorViewContoller(student: object[indexPath.row], block: { [ weak self] (student) in
            self?.coreDataService.saveContext()
            self?.loadStudents()
        })
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UITableViewDataSource -
extension StudentViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students != nil ? students?.count ?? 0 : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath)
        setupCell(cell: cell, withSource: students![indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let object = students![indexPath.row]
            coreDataService.deleteObject(object : object)
            students?.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

