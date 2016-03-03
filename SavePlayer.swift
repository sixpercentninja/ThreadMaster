//
//  SavePlayer.swift
//  ThreadMagic
//
//  Created by Wong You Jing on 02/03/2016.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class SavePlayer: NSManagedObject {

    static var currentPlayer: SavePlayer{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        let personFetch = NSFetchRequest(entityName: "SavePlayer")
        do{
            let array = try moc.executeFetchRequest(personFetch) as! [SavePlayer]
            return array[0]
        } catch{
            fatalError()
        }
    }

}
