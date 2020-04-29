//
//  File.swift
//  CoreDataSW
//
//  Created by Marentilo on 05.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit
import CoreData
import Foundation
 
class StudentCD: NSManagedObject {
    
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var Name: String?
    
}
