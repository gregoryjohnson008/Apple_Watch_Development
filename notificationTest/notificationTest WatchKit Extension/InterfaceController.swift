//
//  InterfaceController.swift
//  notificationTest WatchKit Extension
//
//  Created by Greg Johnson on 9/9/15.
//  Copyright © 2015 Thingee Corporation. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController
{
    
    //fast: 180
    //mid-range: 80
    //slow: 55
    //sedated: 30
    
    var currentBeatPatternIndex = 0
    
    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func handleActionWithIdentifier(identifier: String?, forRemoteNotification remoteNotification: [NSObject : AnyObject])
    {
        print("In handle function")
        if let notificationIdentifier = identifier
        {
            if notificationIdentifier == "firstButtonAction"
            {
                
            }
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
