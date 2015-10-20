//
//  workout.swift
//  full_demo
//
//  Created by Greg Johnson on 10/13/15.
//  Copyright © 2015 thingee. All rights reserved.
//

import Foundation
import HealthKit

struct gl_workout
{
    let healthStore = HKHealthStore()
    var workoutSession:HKWorkoutSession!
    var sessionGoing :Bool = false
    var query:HKQuery?
}

var workout:gl_workout = gl_workout()