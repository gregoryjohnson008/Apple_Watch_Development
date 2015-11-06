//
//  tableObjects.swift
//  full_demo
//
//  Created by Greg Johnson on 10/28/15.
//  Copyright © 2015 thingee. All rights reserved.
//

import Foundation
import UIKit

struct gl_tableObjects {
    
    var lblsArray:[String]  //text for each table element
    
    let colorArray:[UIColor] = [UIColor.whiteColor(), UIColor.redColor(), UIColor.orangeColor(), UIColor.yellowColor(), UIColor.greenColor(), UIColor.blueColor(), UIColor.purpleColor(), UIColor.brownColor()] // select from
    
    var colorInd:[Int]      //index of color selected for each table row
    
    var interval:Reminder   //current working reminder period
    var rems:[Reminder]     //holds reminders periods for each item
    
    var remHour:[Int]       //hour reminder for each item (picker 1)
    var remMin:[Int]        //minute reminder for each item (picker 2)
    var remInterval:[Int]   //interval reminder for each item (picker 3)
    
    var tempName:String
    var tempColorInd:Int
    
    var removing:Bool       //currently removing items?
    
    var count:Int = 0       //total number of items
    
    var run1:Bool = true    //true only when its the first item being added
    
    init(startVal: Int)
    {
        self.lblsArray = ["Force Touch to add"]
        self.colorInd = [startVal]
        self.tempName = "aaaaa"
        self.tempColorInd = startVal
        self.interval = Reminder.Hourly
        self.remHour = [startVal]
        self.remMin = [startVal]
        self.remInterval = [startVal]
        self.removing = false
        self.rems = [Reminder.Hourly]
    }
    
    mutating func addToArrays(hr:Int, mn:Int, ival:Int)
    {
        lblsArray.append(self.tempName)
        colorInd.append(self.tempColorInd)
        remHour.append(hr)
        remMin.append(mn)
        remInterval.append(ival)
        rems.append(self.interval)
        
        count++
    }
    
    mutating func removeFromArrays(index:Int)
    {
        lblsArray.removeAtIndex(index)
        colorInd.removeAtIndex(index)
        remHour.removeAtIndex(index)
        remMin.removeAtIndex(index)
        remInterval.removeAtIndex(index)
        rems.removeAtIndex(index)
        
        count--
    }
    
    mutating func changeElemFromArrays(index:Int, hr:Int, mn:Int, ival:Int)
    {
        remHour[index] = hr
        remMin[index] = mn
        remInterval[index] = ival
    }
}
enum Reminder
{
    case Hourly
    case Daily
    case Weekly
}

var tableRows: gl_tableObjects = gl_tableObjects(startVal: 0)