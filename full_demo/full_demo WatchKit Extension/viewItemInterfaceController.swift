//
//  viewItemInterfaceController.swift
//  full_demo
//
//  Created by Greg Johnson on 11/3/15.
//  Copyright © 2015 thingee. All rights reserved.
//

import Foundation
import WatchKit

class ViewItemController: WKInterfaceController
{
    @IBOutlet var topLabel: WKInterfaceLabel!
    @IBOutlet var bottomLabel: WKInterfaceLabel!
    @IBOutlet var hourPicker: WKInterfacePicker!
    @IBOutlet var minutePicker: WKInterfacePicker!
    @IBOutlet var intervalPicker: WKInterfacePicker!
    
    var clickedInd:Int = -1
    
    var hours:[WKPickerItem] = [WKPickerItem()]
    var mins:[WKPickerItem] = [WKPickerItem()]
    var inter:[WKPickerItem] = [WKPickerItem()]
    
    var tempH:Int = 0
    var tempM:Int = 0
    var tempI:Int = 0
    
    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        
        let index = context as! Int
        clickedInd = index
        
    }
    
    override func willActivate()
    {
            super.willActivate()
        
        switch tableRows.rems[clickedInd]
        {
        case Reminder.Hourly:
            topLabel.setText("First reminder:")
            bottomLabel.setText("Reminding after this many hours:")
        case Reminder.Daily:
            topLabel.setText("Daily reminder at:")
            bottomLabel.setText("Start after this many days:")
        case Reminder.Weekly:
            topLabel.setText("Weekly reminder at:")
            bottomLabel.setText("Day of the week:")
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
        if(tableRows.rems[clickedInd] == Reminder.Weekly)
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
        else if(tableRows.rems[clickedInd] == Reminder.Daily)
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
        
        hourPicker.setSelectedItemIndex(tableRows.remHour[clickedInd])          //hour corresponds to index
        minutePicker.setSelectedItemIndex(tableRows.remMin[clickedInd])
        intervalPicker.setSelectedItemIndex(tableRows.remInterval[clickedInd])  //interval corresponds to index
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
    
    override func didDeactivate()
    {
        super.didDeactivate()
        tableRows.changeElemFromArrays(clickedInd, hr: tempH, mn: tempM, ival: tempI)
    }
    
}
