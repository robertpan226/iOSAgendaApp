//
//  TaskDetailViewController.swift
//  CalenderApp
//
//  Created by Robert Pan on 2016-04-08.
//  Copyright © 2016 Robert Pan. All rights reserved.
//

import UIKit
import CoreData

class TaskDetailViewController: UIViewController {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var informationDetails: UITextView!
    @IBOutlet weak var dueDate: UIDatePicker!
    
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        informationDetails.layer.borderWidth = 0.75
        informationDetails.layer.borderColor = UIColor.lightGrayColor().CGColor
        informationDetails.layer.cornerRadius = 5
        informationDetails.clipsToBounds = true
        taskName.layer.borderWidth = 0.75
        taskName.layer.borderColor = UIColor.lightGrayColor().CGColor
        taskName.layer.cornerRadius = 5
        taskName.clipsToBounds = true
        dueDate.layer.borderWidth = 0.75
        dueDate.layer.borderColor = UIColor.lightGrayColor().CGColor
        dueDate.layer.cornerRadius = 5
        dueDate.clipsToBounds = true
       
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func saveTask() {
        //1
        
        let name = taskName.text!
        let detail = informationDetails.text!
        
        //let dateFormatter = NSDateFormatter()
        //dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        //let date = dateFormatter.stringFromDate(dueDate.date)
        
        let managedContextObject = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Task", inManagedObjectContext:managedContextObject)
        
        let task = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContextObject)
        
        //3
        task.setValue(name, forKey: "name")
        task.setValue(detail, forKey: "detail")
        task.setValue(dueDate.date, forKey: "date")
        
        //4
        do {
            try managedContextObject.save()
            //5
        
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
}
