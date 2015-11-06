//
//  InterfaceController.swift
//  full_demo WatchKit Extension
//
//  Created by Greg Johnson on 10/8/15.
//  Copyright © 2015 thingee. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    let session: WCSession!
    
    override init()
    {
        if(WCSession.isSupported())
        {
            session = WCSession.defaultSession()
        }
        else
        {
            session = nil
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if(workout.sessionGoing)
        {
            workout.healthStore.endWorkoutSession(workout.workoutSession)
        }
    }
    func workoutDidEnd(date : NSDate) {
        if(workout.query != nil)
        {
            workout.healthStore.stopQuery(workout.query!)
            workout.sessionGoing = false
        } else {
            print("******************CAN NOT STOP**********************")
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        tableRows.removing = false
    }

}
