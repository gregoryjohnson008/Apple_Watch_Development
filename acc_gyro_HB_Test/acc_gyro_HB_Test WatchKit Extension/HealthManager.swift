//
//  HealthManager.swift
//  acc_gyro_HB_Test
//
//  Created by Greg Johnson on 9/16/15.
//  Copyright © 2015 Thingee Corporation. All rights reserved.
//

import Foundation
import HealthKit

class HealthManager
{
    let healthKitStore:HKHealthStore = HKHealthStore()
    
    func athorizeHealthKit(completion: ((success:Bool, error:NSError!) -> Void)!)
    {
        //To read
        let healthKitTypesToRead = Set([
            HKObjectType.characteristicTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!,
            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!,
            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBloodType)!,
            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!,
            HKQuantityType.workoutType()
        ])
        
        //To write
        let healthKitTypesToWrite = Set([
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!,
            HKQuantityType.workoutType()
        ])
        
        //Check if health data is available
        if( !HKHealthStore.isHealthDataAvailable())
        {
            let error = NSError(domain: "com.thingee", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            if(completion != nil)
            {
                completion(success:false, error:error)
            }
            return
        }
        
        //Request authorization
        healthKitStore.requestAuthorizationToShareTypes(healthKitTypesToWrite, readTypes: healthKitTypesToRead){
            (success, error) -> Void in
                if(completion != nil)
                {
                    completion(success:success, error:error)
                }
                
        }
        
    }
    
    func readProfile() -> (age:Int?, biologicalsex:HKBiologicalSexObject?, bloodtype:HKBloodTypeObject?)
    {
        var error:NSError?
        
        var age:Int?
        var biologicalSex:HKBiologicalSexObject?
        var bloodType:HKBloodTypeObject?
        
        //Birthday
        do {
            let birthDay = try healthKitStore.dateOfBirth()
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
            print("Error reading birthday: \(error)")
            error = nil
        }
        
        //Biological Sex
        do {
            biologicalSex = try healthKitStore.biologicalSex()
        } catch let error1 as NSError
        {
            error = error1
            biologicalSex = nil
        }
        
        if(error != nil)
        {
            print("Error reading biological sex: \(error)")
            error = nil
        }
        
        //Blood Type
        do {
            bloodType = try healthKitStore.bloodType()
        } catch let error1 as NSError
        {
            error = error1
            bloodType = nil
        }
        
        if error != nil
        {
            print("Error reading Blood Type: \(error)")
            error = nil
        }
        
        return(age, biologicalSex, bloodType)
    }
    
    func readMostRecentSample(sampleType:HKSampleType , completion: ((HKSample!, NSError!) -> Void)!)
    {
        
        //Build the Predicate
        let past = NSDate.distantPast() 
        let now   = NSDate()
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate:now, options: .None)
        
        //Build the sort descriptor to return the samples in descending order
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        let limit = 1 //most recent
        
        //Build samples query
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor])
            { (sampleQuery, results, error ) -> Void in
                
                if error != nil {
                    completion(nil,error)
                    return
                }
                
                // Get the first sample
                let mostRecentSample = results!.first as? HKQuantitySample
                
                // Execute the completion closure
                if completion != nil {
                    completion(mostRecentSample,nil)
                }
        }
        //Execute the Query
        self.healthKitStore.executeQuery(sampleQuery)
    }
    
}