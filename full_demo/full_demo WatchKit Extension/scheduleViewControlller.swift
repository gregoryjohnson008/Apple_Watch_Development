//
//  scheduleViewControlller.swift
//  full_demo
//
//  Created by Gregory Johnson on 10/29/15.
//  Copyright © 2015 thingee. All rights reserved.
//

import Foundation
import WatchKit

class ScheduleController: WKInterfaceController
{
    
    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
    }
    
    override func willActivate()
    {
        super.willActivate()
        
        if(tableRows.tempColorInd == -1)
        {
            popController()
        }
    }
    
    @IBAction func hourlyHit()
    {
        tableRows.interval = Reminder.Hourly
        pushControllerWithName("reminderController", context: nil)
    }
    @IBAction func dailyHit()
    {
        tableRows.interval = Reminder.Daily
        pushControllerWithName("reminderController", context: nil)
    }
    @IBAction func weeklyHit()
    {
        tableRows.interval = Reminder.Weekly
        pushControllerWithName("reminderController", context: nil)
    }
    
    override func didDeactivate()
    {
        super.didDeactivate()
    }
    
}