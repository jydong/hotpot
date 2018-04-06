//  Corresponding to the AddNoteview which shows up after the user pressing the addnote button from the popoverview
//  Has a text entering field and a addnote button for saving the text entered
//  AddNotesViewController.swift
//  Hotpot
//
//  Created by Xuning Wang on 4/2/18.
//  Copyright © 2018 Jingyan Dong. All rights reserved.
//

import UIKit
import CoreData
class AddNotesViewController: UIViewController {
    //field for notes
    @IBOutlet weak var notesTextField: UITextField!
    
    @IBOutlet weak var test: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //try to save the notes after the user press the addnote button
    @IBAction func addNotes(_ sender: UIButton) {
        if let string = notesTextField.text {
        test.text = string
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newNote = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: context)
        newNote.setValue(string, forKey: "note")
        do
        {
            try context.save()
            print("save")
        }
        catch{
            
        }
    }
        
        
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let entry = Entry(context: context)
//        entry.note = notesTextField.text!
//        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
