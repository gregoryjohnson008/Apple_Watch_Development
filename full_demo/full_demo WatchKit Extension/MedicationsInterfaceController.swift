//
//  MedicationsInterfaceController.swift
//  full_demo
//
//  Created by Greg Johnson on 10/28/15.
//  Copyright © 2015 thingee. All rights reserved.
//

import WatchKit
import Foundation

class MedicationsController: WKInterfaceController
{
    @IBOutlet var table: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
    }
    
    func loadTableData()
    {
        table.setNumberOfRows(tableRows.lblsArray.count, withRowType: "firstRow")
        for(var i = 0; i < tableRows.lblsArray.count; i++)
        {
            let row = table.rowControllerAtIndex(i) as! firstRowController
            
            row.label.setText(tableRows.lblsArray[i])
            
            let image = getImageWithColor(tableRows.colorArray[tableRows.colorInd[i]], size: CGSize(width: 5, height: 5))
            row.image.setImage(image)
        }
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
    
    @IBAction func addItem()
    {
        tableRows.removing = false
        pushControllerWithName("addItemToList", context: nil)
    }
    
    @IBAction func removeItem()
    {
        print("Remove called")
        print(tableRows.removing)
        if(!tableRows.removing)
        {
            print("First")
            for(var i = 0; i < tableRows.count; i++)
            {
                let row = table.rowControllerAtIndex(i) as! firstRowController
                let image:UIImage = UIImage(named: "minus_red")!
                row.image.setImage(image)
            }
            tableRows.removing = true
        }
        else
        {
            print("Second")
            loadTableData()
            tableRows.removing = false
        }
        print(tableRows.removing)
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int)
    {
        if(tableRows.removing && tableRows.count > 1)
        {
            tableRows.removeFromArrays(rowIndex)
            
            tableRows.removing = false
            
            loadTableData()
        }
        else
        {
            //go into viewing interface controller
            presentControllerWithName("viewController", context: rowIndex)
        }
    }
    
    override func willActivate()
    {
        super.willActivate()
        
        tableRows.tempColorInd = 0
        
        loadTableData()
    }
    
    override func didDeactivate()
    {
        super.didDeactivate()
    }
}