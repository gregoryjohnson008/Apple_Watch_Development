//
//  InterfaceController.swift
//  sendInfo WatchKit Extension
//
//  Created by Greg Johnson on 9/4/15.
//  Copyright © 2015 Thingee Corporation. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var lblGet: WKInterfaceLabel!
    @IBOutlet var lblToSend: WKInterfaceLabel!
    
    var point:Int = 0
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
    
    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
    }
    
    override func willActivate()
    {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if (WCSession.isSupported())
        {
            session.delegate = self
            session.activateSession()
        }
        self.lblToSend.setText(String(point))
    }

    @IBAction func addToNum()
    {
        self.lblToSend.setText(String(++point))
    }
    
    @IBAction func subFromNum()
    {
        self.lblToSend.setText(String(--point))
    }

    @IBAction func sendMessage()
    {
        print("watchOS: send")
        
        let dict = ["point": point]
        
        print("Sending: \(point)")
        
        session.sendMessage(dict,
            replyHandler: { (content:[String : AnyObject]) -> Void in
                print("Sent something back")
            },
            errorHandler: { (error) -> Void in
            print("We got an error from our paired device: " + error.domain)
        })
        self.lblGet.setText("Sent")
    }
    
    /* Called when message is received */
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void)
    {
        print("watchOS: session")
        
        let data = message["message"] as! String?
        
        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.lblGet.setText(data!)
            })
        }
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
