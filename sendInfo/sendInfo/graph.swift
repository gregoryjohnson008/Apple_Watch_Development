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
    
    init(startPoints: [Int])
    {
        self.points = startPoints
    }
}

var graph: gl_graph = gl_graph(startPoints: [0])