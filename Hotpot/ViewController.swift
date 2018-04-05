//
//  ViewController.swift
//  Hotpot
//
//  Created by Jingyan Dong on 4/2/18.
//  Copyright © 2018 Jingyan Dong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    //@IBOutlet weak var menuButton: UIBarButtonItem!
    
//    var entry:[Entry]? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        sideMenus()
        
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
