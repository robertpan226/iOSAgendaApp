//
//  DetailViewController.swift
//  CalenderApp
//
//  Created by Robert Pan on 2016-04-12.
//  Copyright © 2016 Robert Pan. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    var initial = true
    var counter: Int = 0
    var index: Int = 0
    var editButtonText: String = "Edit"

    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var taskField: UITextField!
    
    @IBOutlet weak var detailText: UITextView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func userTappedBackground(sender: AnyObject) { //Allows keyboard to disappear once user touches background
        view.endEditing(true)
    }
    
    func changeText(){
        if (counter == 0){
            editButtonText = "Done"
            taskField.userInteractionEnabled = true
            detailText.userInteractionEnabled = true
            counter = 1
            viewDidLoad()
        }else{
            saveObject("name", newString: taskField.text!)
            saveObject("detail", newString: detailText.text)
            editButtonText = "Edit"
            taskField.userInteractionEnabled = false
            detailText.userInteractionEnabled = false
            counter = 0
            viewDidLoad()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var dateHolder: String = ""
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "HH:MM MM-dd-yyyy"
        
        dateHolder = dateFormatter.stringFromDate(fetchDate("date"))
        
        taskField.text = fetchObject("name")
        detailText.text = fetchObject("detail")
        dateLabel.text = "Due Date: \(dateHolder) "
        
        if (initial == true){
            taskField.userInteractionEnabled = false
            initial = false
        }
        
        taskField.layer.borderWidth = 0.75
        taskField.layer.borderColor = UIColor.lightGrayColor().CGColor
        taskField.layer.cornerRadius = 5
        taskField.clipsToBounds = true
        detailText.layer.borderWidth = 0.75
        detailText.layer.borderColor = UIColor.lightGrayColor().CGColor
        detailText.layer.cornerRadius = 5
        detailText.clipsToBounds = true
        dateLabel.layer.borderWidth = 0.75
        dateLabel.layer.borderColor = UIColor.lightGrayColor().CGColor
        dateLabel.layer.cornerRadius = 5
        dateLabel.clipsToBounds = true
        
        let editButton = UIBarButtonItem(title: editButtonText, style: .Plain, target: self, action:  #selector(DetailViewController.changeText)) // Creating the button programmically
        
        navigationItem.rightBarButtonItems = [editButton] //Adding Buttons onto Navigation Bar
        
        taskField.layer.borderWidth = 0.75
        taskField.layer.borderColor = UIColor.lightGrayColor().CGColor
        taskField.layer.cornerRadius = 5
        taskField.clipsToBounds = true
    }
    
    func fetchObject(returnType: String) -> String{
        let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: managedObjectContext)
        
        let fetchRequest = NSFetchRequest()
        
        fetchRequest.entity = entityDescription
        
        do {
            let fetchedResult = try managedObjectContext.executeFetchRequest(fetchRequest)
            
            let convertedObjects = fetchedResult[index] as! NSManagedObject
            
            convertedObjects.valueForKey(returnType)
            
            let cellText = fetchedResult[index] as! NSManagedObject
            
            return ((cellText.valueForKey(returnType) as! String))
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    
        return "error"
    }
    
    func saveObject(returnType: String, newString: String){
        let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: managedObjectContext)
        
        let fetchRequest = NSFetchRequest()
        
        fetchRequest.entity = entityDescription
        
        do {
            let fetchedResult = try managedObjectContext.executeFetchRequest(fetchRequest)
            
            let convertedObjects = fetchedResult[index] as! NSManagedObject
            
            convertedObjects.valueForKey(returnType)
            
            let cellText = fetchedResult[index] as! NSManagedObject
            
            cellText.setValue(newString, forKey: returnType)
            
            try managedObjectContext.save()
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    func fetchDate(returnType: String) -> NSDate{
        let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: managedObjectContext)
        
        let fetchRequest = NSFetchRequest()
        
        let date: NSDate = NSDate.distantPast()
        
        fetchRequest.entity = entityDescription
        
        do {
            let fetchedResult = try managedObjectContext.executeFetchRequest(fetchRequest)
            
            let convertedObjects = fetchedResult[index] as! NSManagedObject
            
            convertedObjects.valueForKey(returnType)
            
            let cellText = fetchedResult[index] as! NSManagedObject
            
            return cellText.valueForKey(returnType) as! (NSDate)!
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return date
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

