//
//  CoreDataHandler.swift
//  Hotpot
//
//  Created by Xuning Wang on 4/4/18.
//  Copyright © 2018 Jingyan Dong. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandler: NSObject  {
    private class func getContext() -> NSManagedObjectContext{
        let appleDelegate = UIApplication.shared.delegate as! AppDelegate
        return appleDelegate.persistentContainer.viewContext
    }
    
    class func saveObject(note: String) -> Bool{
        let context = CoreDataHandler.getContext()
        let entry = NSEntityDescription.entity(forEntityName: "Entry", in: context)
        let manageObject = NSManagedObject(entity: entry!, insertInto: context)
        
        manageObject.setValue(note, forKey: "note")
        
        do{
            try context.save()
            return true
        }catch{
            return false
        }
    }
    
    class func fetchObject() -> [Entry]?{
        let context = getContext()
        var entry:[Entry]? = nil
        do{
            entry = try context.fetch(Entry.fetchRequest())
            return entry
        }catch{
            return entry
        }
    }
    

}
