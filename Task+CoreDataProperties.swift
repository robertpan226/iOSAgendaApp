//
//  Task+CoreDataProperties.swift
//  CalenderApp
//
//  Created by Robert Pan on 2016-04-19.
//  Copyright © 2016 Robert Pan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Task {

    @NSManaged var detail: String?
    @NSManaged var date: NSDate?
    @NSManaged var name: String?
    @NSManaged var index: NSNumber?

}
