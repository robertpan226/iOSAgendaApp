//
//  CalendarViewController.swift
//  CalenderApp
//
//  Created by Robert Pan on 2016-04-20.
//  Copyright © 2016 Robert Pan. All rights reserved.
//

import UIKit
import EventKit


class CalendarViewController: UIViewController {

    let eventStore = EKEventStore()
    var calendars: [EKCalendar]?
    
    @IBOutlet var needsPermissionView: UIView!
    @IBOutlet weak var permissionTableView: UITableView!
    @IBAction func goToSettingsButtonTapped(sender: UIButton) {
        let openSettingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(openSettingsUrl!)
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        let newCalendar = EKCalendar(forEntityType: .Event, eventStore: eventStore)
        
        newCalendar.title = "Upcoming Tasks"
        
        let sourcesInEventStore = eventStore.sources
        
        newCalendar.source = sourcesInEventStore.filter{
            (source: EKSource) -> Anyobject in source.sourceType.rawValue == EKSourceType.Local.rawValue
        }.first!
        
        do {
            try eventStore.saveCalendar(newCalendar, commit: true)
            NSUserDefaults.standardUserDefaults().setObject(newCalendar.calendarIdentifier, forKey: "EventTrackerPrimaryCalendar")
        } catch {
            let alert = UIAlertController(title: "Calendar could not save", message: (error as NSError).localizedDescription, preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(OKAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    override func viewDidAppear(animated: Bool){
        checkCalendarAuthorizationStatus()
    }
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        
        switch (status) {
        case EKAuthorizationStatus.NotDetermined:
            // This happens on first-run
            requestAccessToCalendar()
        case EKAuthorizationStatus.Authorized:
            // Things are in line with being able to show the calendars in the table view
            loadCalendars()
            refreshTableView()
        case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied:
            // We need to help them give us permission
            needsPermissionView.fadeIn()
        }
    }
    
    func requestAccessToCalendar() {
        eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
            (accessGranted: Bool, error: NSError?) in
            
            if accessGranted == true {
                dispatch_async(dispatch_get_main_queue(), {
                    self.loadCalendars()
                    self.refreshTableView()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.needsPermissionView.fadeIn()
                })
            }
        })
    }
    
    func loadCalendars() {
        self.calendars = eventStore.calendarsForEntityType(EKEntityType.Event)
    }
    
    func refreshTableView() {
        permissionTableView.hidden = false
        permissionTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIView {
    func fadeIn() {
        // Move our fade out code from earlier
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
            }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.alpha = 0.0
            }, completion: nil)
    }
}