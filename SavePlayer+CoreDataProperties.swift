//
//  SavePlayer+CoreDataProperties.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 02/03/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SavePlayer {

    @NSManaged var totalExperience: NSNumber?
    @NSManaged var skills: NSData?
    @NSManaged var mapLevel: NSNumber?
    @NSManaged var maxHP: NSNumber?
    @NSManaged var playerSkill: NSSet?

}
