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


class HealthHeartRateController: WKInterfaceController, HKWorkoutSessionDelegate {
    
    @IBOutlet private weak var label: WKInterfaceLabel!
    @IBOutlet private weak var deviceLabel : WKInterfaceLabel!
    @IBOutlet private weak var heart: WKInterfaceImage!
    @IBOutlet private weak var bpm: WKInterfaceLabel!
    
    let healthStore = HKHealthStore()
    
    // define the activity type and location
    let workoutSession = HKWorkoutSession(activityType: HKWorkoutActivityType.CrossTraining, locationType: HKWorkoutSessionLocationType.Indoor)
    let heartRateUnit = HKUnit(fromString: "count/min")
    var anchor = HKQueryAnchor(fromValue: Int(HKAnchoredObjectQueryNoAnchor))
    
    //Upper and lower bounds of healthy workout heart rate
    var bounds:[UInt16] = [0, 0]
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        workoutSession.delegate = self
    }
    
    override func willActivate() {
        super.willActivate()
        
        guard HKHealthStore.isHealthDataAvailable() == true else {
            label.setText("not available")
            return
        }
        
        guard let quantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate) else {
            displayNotAllowed()
            return
        }
        
        let DOBType = HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!
        
        let dataTypes = Set([quantityType, DOBType])
        healthStore.requestAuthorizationToShareTypes(nil, readTypes: dataTypes) { (success, error) -> Void in
            if success == false {
                self.displayNotAllowed()
            }
        }
    }
    
    func displayNotAllowed() {
        label.setText("not allowed")
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
    
    func workoutDidStart(date : NSDate) {
        if let query = createHeartRateStreamingQuery(date) {
            healthStore.executeQuery(query)
        } else {
            label.setText("cannot start")
        }
    }
    
    func workoutDidEnd(date : NSDate) {
        if let query = createHeartRateStreamingQuery(date) {
            healthStore.stopQuery(query)
            label.setText("Stop")
        } else {
            label.setText("cannot stop")
        }
    }
    
    func readBDay() -> Int?
    {
        var error:NSError?
        var age:Int?
        
        //Birthday
        do {
            let birthDay = try healthStore.dateOfBirth()
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
    
    // MARK: - Actions
    @IBAction func startBtnTapped() {
        healthStore.startWorkoutSession(workoutSession)
    }
    
    @IBAction func stopBtnTapped() {
        healthStore.endWorkoutSession(workoutSession)
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
            self.label.setText(String(UInt16(value)))
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
    
    func inWorkoutHeartRateZone(heartRate:UInt16) -> Bool
    {
        guard let age = self.readBDay() else {return false}
        var toRet:Bool = false
        
        if(bounds[0] == 0) //needs to be set the first time
        {
            bounds[0] = UInt16(Double(220 - age)*0.5)
            bounds[1] = UInt16(Double(220 - age)*0.85)
        }
        
        self.bpm.setText("BPM Aim\n\(bounds[0])-\(bounds[1])")
        
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
