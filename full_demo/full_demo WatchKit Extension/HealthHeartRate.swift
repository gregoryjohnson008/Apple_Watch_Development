//
//  HealthHeartRate.swift
//  acc_gyro_HB_Test
//
//  Created by Greg Johnson on 9/16/15.
//  Copyright © 2015 Thingee Corporation. All rights reserved.
//

import Foundation
import HealthKit
import WatchKit
import WatchConnectivity

class HealthHeartRateController: WKInterfaceController, HKWorkoutSessionDelegate, WCSessionDelegate {
    
    @IBOutlet private weak var bpmNum: WKInterfaceLabel!
    @IBOutlet private weak var deviceLabel : WKInterfaceLabel!
    @IBOutlet private weak var heart: WKInterfaceImage!
    @IBOutlet private weak var bpmAim: WKInterfaceLabel!
    
    // define the activity type and location
    let heartRateUnit = HKUnit(fromString: "count/min")
    var anchor = HKQueryAnchor(fromValue: Int(HKAnchoredObjectQueryNoAnchor))
    
    //Upper and lower bounds of healthy workout heart rate
    var bounds:[UInt16] = [0, 0]
    
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
    }
    
    override func willActivate() {
        super.willActivate()
        
        if (WCSession.isSupported())
        {
            session.delegate = self
            session.activateSession()
        }
        
        guard HKHealthStore.isHealthDataAvailable() == true else {
            bpmNum.setText("not available")
            return
        }
        
        guard let quantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate) else {
            displayNotAllowed()
            return
        }
        
        let DOBType = HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!
        
        let dataTypes = Set([quantityType, DOBType])
        workout.healthStore.requestAuthorizationToShareTypes(nil, readTypes: dataTypes) { (success, error) -> Void in
            if success == false {
                self.displayNotAllowed()
            }
        }
    }
    
    func displayNotAllowed() {
        bpmNum.setText("not allowed")
    }
    
    func workoutSession(workoutSession: HKWorkoutSession, didChangeToState toState: HKWorkoutSessionState, fromState: HKWorkoutSessionState, date: NSDate) {
        switch toState {
        case .Running:
            workoutDidStart(date)
        case .Ended:
            workoutDidEnd(date)
        default:
            print("Unexpected state \(toState)")
        }
    }
    
    func workoutSession(workoutSession: HKWorkoutSession, didFailWithError error: NSError) {
        // Do nothing for now
    }
    
    func workoutDidStart(date : NSDate)
    {
        workout.query = createHeartRateStreamingQuery(date)
        if (workout.query != nil) {
            workout.healthStore.executeQuery(workout.query!)
            workout.sessionGoing = true
            bpmNum.setText("...")
        } else {
            bpmNum.setText("cannot start")
        }
    }
    
    func workoutDidEnd(date : NSDate) {
        if(workout.query != nil)
        {
            workout.healthStore.stopQuery(workout.query!)
            workout.sessionGoing = false
            bpmNum.setText("Stop")
        } else {
            bpmNum.setText("cannot stop")
        }
    }
    
    func readBDay() -> Int?
    {
        var error:NSError?
        var age:Int?
        
        //Birthday
        do {
            let birthDay = try workout.healthStore.dateOfBirth()
            let today = NSDate()
            let differenceComponents = NSCalendar.currentCalendar().components(.Year, fromDate: birthDay, toDate: today, options: NSCalendarOptions(rawValue: 0))
            age = differenceComponents.year
        }
        catch let error1 as NSError
        {
            error = error1
        }
        
        if(error != nil)
        {
            print("Error with age: \(error)")
        }
        
        return age
    }
    
    //  Sends -1 to indicate save graph
    @IBAction func saveGraph()
    {
        print("watchOS: send")
        
        let dict = ["point": -1]
        
        print("Sending: -1")
        
        session.sendMessage(dict,
            replyHandler: { (content:[String : AnyObject]) -> Void in
                print("Sent something back")
            },
            errorHandler: { (error) -> Void in
                print("We got an error from our paired device: " + error.domain)
        })
    }
    
    //  Sends -5 to to indicate clear graph
    @IBAction func clearGraph()
    {
        print("watchOS: send")
        
        let dict = ["point": -5]
        
        print("Sending: -5")
        
        session.sendMessage(dict,
            replyHandler: { (content:[String : AnyObject]) -> Void in
                print("Sent something back")
            },
            errorHandler: { (error) -> Void in
                print("We got an error from our paired device: " + error.domain)
        })
    }
    
    //  Sends -13 to indicate increase data point limit
    @IBAction func addDataPoints()
    {
        print("watchOS: send")
        
        let dict = ["point": -13]
        
        print("Sending: -13")
        
        session.sendMessage(dict,
            replyHandler: { (content:[String : AnyObject]) -> Void in
                print("Sent something back")
            },
            errorHandler: { (error) -> Void in
                print("We got an error from our paired device: " + error.domain)
        })
    }
    
    //Start and stop reading/sending data
    @IBAction func startBtnTapped()
    {
        if(!workout.sessionGoing)
        {
            workout.workoutSession = HKWorkoutSession(activityType: HKWorkoutActivityType.CrossTraining, locationType: HKWorkoutSessionLocationType.Indoor)
            workout.workoutSession.delegate = self
            workout.healthStore.startWorkoutSession(workout.workoutSession)
        }
    }
    
    @IBAction func stopBtnTapped()
    {
        if(workout.sessionGoing)
        {
            workout.healthStore.endWorkoutSession(workout.workoutSession)
        }
    }
    
    func createHeartRateStreamingQuery(workoutStartDate: NSDate) -> HKQuery? {
        // adding predicate will not work
        // let predicate = HKQuery.predicateForSamplesWithStartDate(workoutStartDate, endDate: nil, options: HKQueryOptions.None)
        
        guard let quantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate) else { return nil }
        
        let heartRateQuery = HKAnchoredObjectQuery(type: quantityType, predicate: nil, anchor: anchor, limit: Int(HKObjectQueryNoLimit)) { (query, sampleObjects, deletedObjects, newAnchor, error) -> Void in
            guard let newAnchor = newAnchor else {return}
            self.anchor = newAnchor
            self.updateHeartRate(sampleObjects)
        }
        
        heartRateQuery.updateHandler = {(query, samples, deleteObjects, newAnchor, error) -> Void in
            self.anchor = newAnchor!
            self.updateHeartRate(samples)
        }
        return heartRateQuery
    }
    
    func updateHeartRate(samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else {return}
        
        dispatch_async(dispatch_get_main_queue()) {
            guard let sample = heartRateSamples.first else{return}
            let value = sample.quantity.doubleValueForUnit(self.heartRateUnit)
            self.bpmNum.setText(String(UInt16(value)))
            self.sendData(Int(value))
            if(self.inWorkoutHeartRateZone(UInt16(value)))
            {
                self.heart.setImageNamed("heart_g")
            }
            else
            {
                self.heart.setImageNamed("heart")
            }
            
            // retrieve source from sample
            let name = sample.sourceRevision.source.name
            self.updateDeviceName(name)
            self.animateHeart()
        }
    }
    
    //  Sends data point to phone for graph
    func sendData(value:Int)
    {
        print("watchOS: send")
        
        let dict = ["point": value]
        
        print("Sending: \(value)")
        
        session.sendMessage(dict,
            replyHandler: { (content:[String : AnyObject]) -> Void in
                print("Sent something back")
            },
            errorHandler: { (error) -> Void in
                print("We got an error from our paired device: " + error.domain)
        })
    }
    
    func inWorkoutHeartRateZone(heartRate:UInt16) -> Bool
    {
        guard let age = self.readBDay() else {
            self.bpmAim.setText("N/A")
            return false
        }
        var toRet:Bool = false
        
        if(bounds[0] == 0) //needs to be set the first time
        {
            bounds[0] = UInt16(Double(220 - age)*0.5)
            bounds[1] = UInt16(Double(220 - age)*0.85)
        }
        
        self.bpmAim.setText("BPM Aim\n\(bounds[0])-\(bounds[1])")
        
        if(heartRate >=  bounds[0] && heartRate <= bounds[1])
        {
            toRet = true
        }
        
        return toRet
    }
    
    func updateDeviceName(deviceName: String) {
        deviceLabel.setText(deviceName)
    }
    
    func animateHeart() {
        self.animateWithDuration(0.5) {
            self.heart.setWidth(50)
            self.heart.setHeight(50)
        }
        
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * double_t(NSEC_PER_SEC)))
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_after(when, queue) {
            dispatch_async(dispatch_get_main_queue(), {
                self.animateWithDuration(0.5, animations: {
                    self.heart.setWidth(25)
                    self.heart.setHeight(25)
                })
            })
        }
    }
}
