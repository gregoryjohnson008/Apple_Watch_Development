//
//  ViewController.swift
//  notificationTest
//
//  Created by Greg Johnson on 9/9/15.
//  Copyright © 2015 Thingee Corporation. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "drawAShape:", name: "actionOnePressed", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showAMessage:", name: "actionTwoPressed", object: nil)
        
        let date = NSDate()
        let cal = NSCalendar.currentCalendar()
        let components = cal.components([.NSYearCalendarUnit, .NSMonthCalendarUnit, .NSDayCalendarUnit, .NSHourCalendarUnit, .NSMinuteCalendarUnit], fromDate: date)
        let dateComp:NSDateComponents = NSDateComponents()
        dateComp.year = components.year
        dateComp.month = components.month
        dateComp.day = components.day
        dateComp.hour = components.hour
        dateComp.minute = components.minute+1
        dateComp.timeZone = NSTimeZone.systemTimeZone()
        
        print("Time of notification: \(dateComp.hour):\(dateComp.minute)")
        
        let calendar:NSCalendar? = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let dateFire:NSDate? = calendar!.dateFromComponents(dateComp)
        
        let notification:UILocalNotification = UILocalNotification()
        notification.category = "firstCategory"
        notification.alertBody = "Hi, I am a notification"
        notification.fireDate = dateFire
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawAShape(notification:NSNotification)
    {
        let view:UIView = UIView(frame: CGRectMake(10, 10, 100, 100))
        view.backgroundColor = UIColor.redColor()
        
        self.view.addSubview(view)
    }
    
    func showAMessage(notification:NSNotification)
    {
        let message:UIAlertController = UIAlertController(title: "A Notification Message", message: "hello there", preferredStyle: UIAlertControllerStyle.Alert)
        message.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(message, animated: true, completion: nil)
    }


}

