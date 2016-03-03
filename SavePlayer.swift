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
            if array.count > 0{
                return array[0]
            }else{
                let player = NSEntityDescription.insertNewObjectForEntityForName("SavePlayer", inManagedObjectContext: moc) as! SavePlayer
                
                player.totalExperience = 100
                player.maxHP = 50
                do {
                    try moc.save()
                }catch{
                    fatalError("failure to save context: \(error)")
                }
                return player
            }
        } catch{
            fatalError()
        }
    }

}
