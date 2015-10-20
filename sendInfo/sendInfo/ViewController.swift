//
//  ViewController.swift
//  sendInfo
//
//  Created by Greg Johnson on 9/4/15.
//  Copyright © 2015 Thingee Corporation. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {

    @IBOutlet var label: UILabel!
    @IBOutlet var textInput: UITextField!
    @IBOutlet var graphView: GraphView!
    
    @IBOutlet var maxLabel: UILabel!
    @IBOutlet var minLabel: UILabel!
    @IBOutlet var average: UILabel!
    
    let session: WCSession!
    
    required init?(coder aDecoder: NSCoder)
    {
        self.session = WCSession.defaultSession()
        super.init(coder: aDecoder)
    }
    
    @IBAction func sendText(sender: AnyObject)
    {
        print("iOS: send")
        
        let message = (textInput.text == "" ? "default" : textInput.text)
        
        let dict = ["message": message!]
        
        session.sendMessage(dict,
            replyHandler: { (content:[String : AnyObject]) -> Void in
                print("Sent something back")
            },
            errorHandler: { (error) -> Void in
                print("We got an error from our paired device: " + error.domain)
        })
    }
    
    /* Called when message is received */
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void)
    {
        print("iOS: session")
        let data = message["point"] as! Int?
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.label.text = "Data point: " + String(data!)
            graph.points.append(data!)
            self.setupGraphDisplay()
        })
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if (WCSession.isSupported())
        {
            session.delegate = self
            session.activateSession()
        }
        
    }
    
    func setupGraphDisplay()
    {
        //indicate that the graph needs to be redrawn
        graphView.setNeedsDisplay()
        let maxVal:Int = max(graph.points.maxElement()!, abs(graph.points.minElement()!))
        maxLabel.text = "\(maxVal)"
        minLabel.text = "-\(maxVal)"
        
        //calculate average from graphPoints
        let averageNum = graph.points.reduce(0, combine: +) / graph.points.count
        average.text = "Average: \(averageNum)"
    }
    func sessionWatchStateDidChange(session: WCSession)
    {
        //called when watch pairs or is unpaired
    }
    
    func sessionReachabilityDidChange(session: WCSession) {
        //called when the app changes from foreground to background and vice versa
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

