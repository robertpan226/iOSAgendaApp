//
//  TaskTableViewController.swift
//  CalenderApp
//
//  Created by Robert Pan on 2016-04-08.
//  Copyright © 2016 Robert Pan. All rights reserved.
//

import UIKit
import CoreData

class TaskTableViewController: UITableViewController{

    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var newTask: String = ""
    var details = [NSManagedObject]()
    var newDetails: String = ""
    var allDates = [NSManagedObject]()
    var newDate: String = ""
    var temp = 0
    var allTasks: [NSManagedObject] = []

    @IBAction func cancel(segue:UIStoryboardSegue) {}
    
    @IBAction func done(segue:UIStoryboardSegue) {
        let taskDetailVC = segue.sourceViewController as! TaskDetailViewController
        
        taskDetailVC.saveTask()
        
        self.tableView.reloadData()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "test"{
            let detailVC = segue.destinationViewController as! DetailViewController
            let indexValue = tableView.indexPathForSelectedRow?.row
            detailVC.index = indexValue!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        
        let moc = managedObjectContext
        let taskFetch = NSFetchRequest(entityName: "Task")
        
        do {
            let numberOfTasks = try moc.executeFetchRequest(taskFetch)
            return numberOfTasks.count
        } catch {
            fatalError("Failed to fetch tasks: \(error)")
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath)
        
        // Configure the cell...
        
        let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: managedObjectContext)

        let fetchRequest = NSFetchRequest()
        
        fetchRequest.entity = entityDescription
       
        do {
            let fetchedResult = try managedObjectContext.executeFetchRequest(fetchRequest)
            
            
            
            
            for objects in fetchedResult {
                let convertedObjects = objects as! NSManagedObject
                convertedObjects.valueForKey("name")
            }
            let cellText = fetchedResult[indexPath.row] as! NSManagedObject
            
            cell.textLabel!.text = ((cellText.valueForKey("name"))! as! String)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return cell
    }
   
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            do {
                let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: managedObjectContext)
                
                let fetchRequest = NSFetchRequest()
                
                fetchRequest.entity = entityDescription
                
                let fetchedObject = try managedObjectContext.executeFetchRequest(fetchRequest)
                
                let deletedObject = fetchedObject[indexPath.row] as! NSManagedObject
                
                self.managedObjectContext.deleteObject(deletedObject)
                
                try self.managedObjectContext.save()
                
            } catch {
                let saveError = error as NSError
                print(saveError)
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            
            self.tableView.reloadData()
        }
    }
}
