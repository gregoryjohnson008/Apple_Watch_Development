//
//  ViewController.swift
//  full_demo
//
//  Created by Greg Johnson on 10/8/15.
//  Copyright © 2015 thingee. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {

    @IBOutlet var received: UILabel!
    @IBOutlet var graphView: GraphView!
    
    @IBOutlet var maxLabel: UILabel!
    @IBOutlet var minLabel: UILabel!
    @IBOutlet var average: UILabel!
    
    let session: WCSession!
    
    var maxInd:Int = 10 //number of values allowed to be graphed
    var firstPoint:Bool = true
    
    let transitionManager = TransitionManager(direction: TransitionManager.Direction.down)
    
    required init?(coder aDecoder: NSCoder)
    {
        self.session = WCSession.defaultSession()
        super.init(coder: aDecoder)
    }
    
    //   For sending text to the watch from the phone
    /*@IBAction func sendText(sender: AnyObject)
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
    }*/
    
    //   Called when data is received from the watch. Creates a new point for the graph
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void)
    {
        print("iOS: session")
        let data = message["point"] as! Int?
        
        if(data >= 0)
        {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.received.text = "Data point received: " + String(data!) + " bpm"
                while(graph.points.count >= self.maxInd)
                {
                    graph.points.removeAtIndex(0)
                }
                graph.points.append(data!)
                
                if(self.firstPoint)
                {
                    graph.points.removeAtIndex(0)
                    self.firstPoint = false
                }
                self.setupGraphDisplay()
            })
        }
        else if(data == -1) //save graph
        {
            graph.savedGraphs.insert(graph.points, atIndex: graph.saveToInd)
            switch graph.saveToInd
            {
            case 0:
                graph.g1Max = graph.points.maxElement()!
                graph.g1Min = graph.points.minElement()!
            case 1:
                graph.g2Max = graph.points.maxElement()!
                graph.g2Min = graph.points.minElement()!
            case 2:
                graph.g3Max = graph.points.maxElement()!
                graph.g3Min = graph.points.minElement()!
            default:
                print("Index is an invalid number")
            }
            graph.savedGraphs.removeAtIndex(graph.saveToInd + 1) //saveToInd has been increased since inserting
            graph.saveToInd = (graph.saveToInd + 1) % 3
            graph.graphNum += 1
        }
        else if(data == -5) //clear graph
        {
            self.resetGraph()
        }
        else if(data == -13) //increase data point limit
        {
            maxInd++
        }
        else
        {
            print("Negative number not recognized")
        }
    }
    
    //  Resets graph to starting state
    func resetGraph()
    {
        graph.points.removeAll()
        graph.points.append(0)
        firstPoint = true
        self.setupGraphDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (WCSession.isSupported())
        {
            session.delegate = self
            session.activateSession()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "startAnotherNotification:", name: "actionOnePressed", object: nil)
        
        let maxVal:Int = graph.points.maxElement()!
        let minVal:Int = graph.points.minElement()!
        maxLabel.text = "\(maxVal)"
        minLabel.text = "\(minVal)"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("*******Will Appear from main view**************")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("*******Did disappear from main view*************")
    }
    
    func startAnotherNotification(notification:NSNotification)
    {
        let localNot:UILocalNotification = UILocalNotification()
        localNot.category = "firstCategory"
        localNot.alertBody = "Come check our your heart rate graph!"
        localNot.fireDate = NSDate(timeIntervalSinceNow: 15) //fired in 15 seconds
        UIApplication.sharedApplication().scheduleLocalNotification(localNot)
    }
    
    //   Redraws the graph with the data points
    func setupGraphDisplay()
    {
        //indicate that the graph needs to be redrawn
        graphView.setNeedsDisplay()
        let maxVal:Int = graph.points.maxElement()!
        let minVal:Int = graph.points.minElement()!
        maxLabel.text = "\(maxVal)"
        minLabel.text = "\(minVal)"
        
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
    
    //Changes the animation between views to the ones created
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "toSavedGraphs")
        {
            transitionManager.changeDir(TransitionManager.Direction.up)
        }
        
        let toViewController = segue.destinationViewController
        // instead of using the default transition animation, we'll ask
        // the segue to use our custom TransitionManager object to manage the transition animation
        toViewController.transitioningDelegate = transitionManager
        
    }


}

