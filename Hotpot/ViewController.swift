//
//  ViewController.swift
//  Hotpot
//
//  Created by Jingyan Dong on 4/2/18.
//  Copyright © 2018 Jingyan Dong. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    //@IBOutlet weak var menuButton: UIBarButtonItem!
    
//    var entry:[Entry]? = nil

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var enties:[Entry] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        sideMenus()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
            if result.count > 0{
                for res in result as! [NSManagedObject]
                {
                    if let notes = res.value(forKey: "note") as? String{
                        print (notes)
                    }
                }
            }
        }
        catch{
            
        }
//        CoreDataHandler.saveObject(note: "apple")
//        entry = CoreDataHandler.fetchObject()
//        
//        for i in entry!{
//            print(i.note)
//        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func sideMenus() {
        if revealViewController() != nil {
            
            
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }


}
