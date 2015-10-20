//
//  InterfaceController.swift
//  acc_gyro_HB_Test WatchKit Extension
//
//  Created by Greg Johnson on 9/14/15.
//  Copyright © 2015 Thingee Corporation. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion


class MotionReadingsController: WKInterfaceController {
    
    
    @IBOutlet var lbl_accel: WKInterfaceLabel!
    @IBOutlet var lbl_gyro: WKInterfaceLabel!
    
    let motionManager = CMMotionManager()
    
    var accelX:Double = 0.0
    var accelY:Double = 0.0
    var accelZ:Double = 0.0
    
    var rotX:Double = 0.0
    var rotY:Double = 0.0
    var rotZ:Double = 0.0
    
    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
    }
    
    func gatherMotionData()
    {
        
        lbl_accel.setText(String(format: "A - \txAccel: %.03f \n\tyAccel: %.03f \n\tzAccel: %.03f", accelX, accelY, accelZ))
        lbl_gyro.setText(String(format: "A - \txAccel: %.03f \n\tyAccel: %.03f \n\tzAccel: %.03f", accelX, accelY, accelZ))
        
        //Motion properties
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.gyroUpdateInterval = 0.2
        
        //Start recording data
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!,
            withHandler: { (accelerometerData: CMAccelerometerData?, error: NSError?) -> Void in
                self.outputAccelerationData(accelerometerData!.acceleration)
                if(error != nil)
                {
                    print("\(error)")
                }
        })
        
        if(motionManager.gyroAvailable)
        {
            motionManager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()!,
                withHandler: { (gyroData: CMGyroData?, error: NSError?) -> Void in
                    self.outputRotationData(gyroData!.rotationRate)
                    if(error != nil)
                    {
                        print("\(error)")
                    }
            })
        }
        else
        {
            lbl_gyro.setText("Gyro not available")
        }
        
    }
    
    func outputAccelerationData(acceleration: CMAcceleration)
    {
        accelX = acceleration.x
        accelY = acceleration.y
        accelZ = acceleration.z
        
        lbl_accel.setText(String(format: "A - \txAccel: %.03f \n\tyAccel: %.03f \n\tzAccel: %.03f", accelX, accelY, accelZ))
        
    }
    
    func outputRotationData(rotation: CMRotationRate)
    {
        print("Gyro called")
        rotX = rotation.x
        rotY = rotation.y
        rotZ = rotation.z
        
        lbl_gyro.setText(String(format: "G - \txRot: %.03f \n\tyRot: %.03f \n\tzRot: %.03f", rotX, rotY, rotZ))
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        gatherMotionData()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
