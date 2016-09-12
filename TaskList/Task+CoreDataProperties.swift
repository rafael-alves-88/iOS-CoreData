//
//  Task+CoreDataProperties.swift
//  TaskList
//
//  Created by Thales Toniolo on 10/6/15.
//  Copyright © 2015 Flameworks. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Task {

    @NSManaged var nome: String?
    @NSManaged var status: Status?

}
