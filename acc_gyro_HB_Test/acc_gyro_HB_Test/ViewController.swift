//
//  ViewController.swift
//  acc_gyro_HB_Test
//
//  Created by Greg Johnson on 9/14/15.
//  Copyright © 2015 Thingee Corporation. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet var lbl_accel: UILabel!
    @IBOutlet var lbl_gyro: UILabel!
    
    let motionManager = CMMotionManager()
    
    var accelX:Double = 0.0
    var accelY:Double = 0.0
    var accelZ:Double = 0.0
    
    var rotX:Double = 0.0
    var rotY:Double = 0.0
    var rotZ:Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        lbl_accel.text = String(format: "A - \txAccel: %.04f \n\tyAccel: %.04f \n\tzAccel: %.04f", accelX, accelY, accelZ)
        lbl_gyro.text = String(format: "G - \txRot: %.04f \n\tyRot: %.04f \n\tzRot: %.04f", rotX, rotY, rotZ)
        
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
        
        motionManager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()!,
            withHandler: { (gyroData: CMGyroData?, error: NSError?) -> Void in
                self.outputRotationData(gyroData!.rotationRate)
                if(error != nil)
                {
                    print("\(error)")
                }
        })
        
    }
    
    func outputAccelerationData(acceleration: CMAcceleration)
    {
        print("Accell called")
        accelX = acceleration.x
        accelY = acceleration.y
        accelZ = acceleration.z
        
        lbl_accel.text = String(format: "A - \txAccel: %.04f \n\tyAccel: %.04f \n\tzAccel: %.04f", accelX, accelY, accelZ)
        
    }
    
    func outputRotationData(rotation: CMRotationRate)
    {
        print("Gyro called")
        rotX = rotation.x
        rotY = rotation.y
        rotZ = rotation.z
        
        lbl_gyro.text = String(format: "G - \txRot: %.04f \n\tyRot: %.04f \n\tzRot: %.04f", rotX, rotY, rotZ)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

