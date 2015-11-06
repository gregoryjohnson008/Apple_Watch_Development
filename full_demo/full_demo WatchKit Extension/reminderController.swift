//
//  hourlyController.swift
//  full_demo
//
//  Created by Gregory Johnson on 10/29/15.
//  Copyright © 2015 thingee. All rights reserved.
//

import Foundation
import WatchKit

class ReminderController: WKInterfaceController
{
    @IBOutlet var topLabel: WKInterfaceLabel!
    @IBOutlet var bottomLabel: WKInterfaceLabel!
    @IBOutlet var hourPicker: WKInterfacePicker!
    @IBOutlet var minutePicker: WKInterfacePicker!
    @IBOutlet var intervalPicker: WKInterfacePicker!
    
    var hours:[WKPickerItem] = [WKPickerItem()]
    var mins:[WKPickerItem] = [WKPickerItem()]
    var inter:[WKPickerItem] = [WKPickerItem()]
    
    var tempH:Int = 0
    var tempM:Int = 0
    var tempI:Int = 0
    
    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
    }
    
    override func willActivate()
    {
        super.willActivate()
        
        switch tableRows.interval
        {
        case Reminder.Hourly:
            topLabel.setText("First reminder at:")
            bottomLabel.setText("Remind after how many hours:")
        case Reminder.Daily:
            topLabel.setText("Daily reminder at:")
            bottomLabel.setText("Start after how many days:")
        case Reminder.Weekly:
            topLabel.setText("Weekly reminder at:")
            bottomLabel.setText("What day of the week:")
        }
        
        for(var i = 0; i < 24; i++)
        {
            let elem:WKPickerItem = WKPickerItem()
            elem.title = String(i)
            hours.append(elem)
        }
        hours.removeAtIndex(0) //remove blank item
        hourPicker.setItems(hours)
        for(var i = 0; i < 60; i++)
        {
            let elem:WKPickerItem = WKPickerItem()
            if(i < 10)
            {
                elem.title = "0" + String(i)
            }
            else
            {
                elem.title = String(i)
            }
            mins.append(elem)
        }
        mins.removeAtIndex(0) //remove blank item
        minutePicker.setItems(mins)
        if(tableRows.interval == Reminder.Weekly)
        {
            let elems:[WKPickerItem] = [WKPickerItem(),WKPickerItem(),WKPickerItem(),WKPickerItem(),WKPickerItem(),WKPickerItem(),WKPickerItem()]
            elems[0].title = "Su"
            elems[1].title = "M"
            elems[2].title = "Tu"
            elems[3].title = "W"
            elems[4].title = "Th"
            elems[5].title = "F"
            elems[6].title = "Sa"
            inter = elems
        }
        else if(tableRows.interval == Reminder.Daily)
        {
            for(var i = 0; i < 7; i++)
            {
                let elem:WKPickerItem = WKPickerItem()
                elem.title = String(i)
                inter.append(elem)
            }
            inter.removeAtIndex(0) //remove blank item
        }
        else
        {
            for(var i = 0; i < 24; i++)
            {
                let elem:WKPickerItem = WKPickerItem()
                elem.title = String(i)
                inter.append(elem)
            }
            inter.removeAtIndex(0) //remove blank item
        }
        intervalPicker.setItems(inter)
    }
    
    @IBAction func hourPickerChanged(value: Int)
    {
        tempH = value //index passed in corresponds to value chosen
    }
    
    @IBAction func minutePickerChanged(value: Int)
    {
        tempM = value //index passed in corresponds to value chosen
    }
    
    @IBAction func intervalPickerChanged(value: Int)
    {
        tempI = value //index passed in corresponds to value chosen
    }
    
    @IBAction func doneClicked()
    {        
        tableRows.addToArrays(tempH, mn: tempM, ival: tempI)
        
        if(tableRows.run1)
        {
            tableRows.removeFromArrays(0)
            
            tableRows.run1 = false
        }
        
        tableRows.tempColorInd = -1
        
        popController()

    }
    
    override func didDeactivate()
    {
        super.didDeactivate()
    }
    
}
