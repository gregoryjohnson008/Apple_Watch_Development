//
//  addItemViewController.swift
//  full_demo
//
//  Created by Greg Johnson on 10/28/15.
//  Copyright © 2015 thingee. All rights reserved.
//

import Foundation
import WatchKit

class addItemController: WKInterfaceController
{
    
    @IBOutlet var letter1: WKInterfacePicker!
    @IBOutlet var letter2: WKInterfacePicker!
    @IBOutlet var letter3: WKInterfacePicker!
    @IBOutlet var letter4: WKInterfacePicker!
    @IBOutlet var letter5: WKInterfacePicker!
    
    @IBOutlet var colorPicker: WKInterfacePicker!
    
    var items:[WKPickerItem] = [WKPickerItem()]
    var name:[String] = ["a", "a", "a", "a", "a"]
    var colorI:Int = 0
    
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
        
        let fullString:String = "abcdefghijklmnopqrstuvwxyz"
        
        for letter in fullString.characters//i starts at 1 because we have already added 'a'
        {
            let elem:WKPickerItem = WKPickerItem()
            elem.title = String(letter)
            items.append(elem)
        }
        
        items.removeAtIndex(0)//remove the first one bc its blank
        
        letter1.setItems(items)
        letter2.setItems(items)
        letter3.setItems(items)
        letter4.setItems(items)
        letter5.setItems(items)
        
        var colors:[WKPickerItem] = [WKPickerItem()]
        var count = 0
        for col in tableRows.colorArray
        {
            let elem:WKPickerItem = WKPickerItem()
            let im:WKImage = WKImage(image: getImageWithColor(col, size: CGSize(width: 75, height: 10)))
            elem.contentImage = im
            switch count
            {
            case 0:
                elem.caption = "Tag white"
            case 1:
                elem.caption = "Tag red"
            case 2:
                elem.caption = "Tag orange"
            case 3:
                elem.caption = "Tag yellow"
            case 4:
                elem.caption = "Tag green"
            case 5:
                elem.caption = "Tag blue"
            case 6:
                elem.caption = "Tag purple"
            case 7:
                elem.caption = "Tag brown"
            default:
                print("Out of color bounds")
            }
            colors.append(elem)
            count++
        }
        
        colors.removeAtIndex(0)//remove the first one bc its blank
        colorPicker.setItems(colors)
        
    }
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage
    {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    @IBAction func picker1(value: Int)
    {
        name[0] = items[value].title!
    }
    
    @IBAction func picker2(value: Int)
    {
        name[1] = items[value].title!
    }
    
    @IBAction func picker3(value: Int)
    {
        name[2] = items[value].title!
    }
    
    @IBAction func picker4(value: Int)
    {
        name[3] = items[value].title!
    }
    
    @IBAction func picker5(value: Int)
    {
        name[4] = items[value].title!
    }
    
    @IBAction func pickerColor(value: Int)
    {
        colorI = value
    }
    
    @IBAction func addSchedule()
    {
        tableRows.tempName = name.joinWithSeparator("")
        tableRows.tempColorInd = colorI
        
        pushControllerWithName("scheduleController", context: nil)
    }
    
    override func didDeactivate()
    {
        super.didDeactivate()
        tableRows.removing = false
    }
}