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
    var dates:[String?]
    var maxMin:[[Int]]
    var saveToInd:Int
    var graphNum:Int = 0
    
    init(startPoints: [Int])
    {
        self.points = startPoints
        self.savedGraphs = [startPoints,startPoints,startPoints]
        self.dates = [nil, nil, nil]
        self.saveToInd = 0
        self.maxMin = [[0,0],[0,0],[0,0]]
    }
}

var graph: gl_graph = gl_graph(startPoints: [0])