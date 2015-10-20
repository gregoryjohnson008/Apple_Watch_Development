//
//  graph.swift
//  sendInfo
//
//  Created by Greg Johnson on 9/9/15.
//  Copyright © 2015 Thingee Corporation. All rights reserved.
//

import Foundation

struct gl_graph
{
    var points:[Int]
    var savedGraphs:[[Int]]
    var saveToInd:Int
    var graphNum:Int = 0
    
    var g1Max:Int
    var g1Min:Int
    var g2Max:Int
    var g2Min:Int
    var g3Max:Int
    var g3Min:Int
    
    init(startPoints: [Int])
    {
        self.points = startPoints
        self.savedGraphs = [startPoints,startPoints,startPoints]
        self.saveToInd = 0
        g1Max = 0
        g1Min = 0
        g2Max = 0
        g2Min = 0
        g3Max = 0
        g3Min = 0
    }
}

var graph: gl_graph = gl_graph(startPoints: [0])