//
//  SavedGraphsViewController.swift
//  full_demo
//
//  Created by Greg Johnson on 10/13/15.
//  Copyright © 2015 thingee. All rights reserved.
//

import UIKit

class SavedGraphsViewController: UIViewController
{
    
    @IBOutlet weak var graph1: SavedGraph!
    @IBOutlet weak var graph2: SavedGraph!
    @IBOutlet weak var graph3: SavedGraph!
    
    @IBOutlet weak var graphTitle1: UILabel!
    @IBOutlet weak var graphTitle2: UILabel!
    @IBOutlet weak var graphTitle3: UILabel!
    
    @IBOutlet weak var graph1Max: UILabel!
    @IBOutlet weak var graph1Min: UILabel!
    @IBOutlet weak var graph2Max: UILabel!
    @IBOutlet weak var graph2Min: UILabel!
    @IBOutlet weak var graph3Max: UILabel!
    @IBOutlet weak var graph3Min: UILabel!
    
    let transitionManager = TransitionManager(direction: TransitionManager.Direction.down)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        displayGraphs()
        
        graph1.alpha = 0.0
        graph2.alpha = 0.0
        graph3.alpha = 0.0
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        var order:Int = 0
        
        // Determines order of fading in. Starts from the right most digit
        switch graph.saveToInd
        {
        case 1:
            order = 231//132
        case 2:
            order = 312//213
        case 0:
            order = 123//321
        default:
            print("Something went wrong")
        }
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
        
            if(graph.graphNum < 1)
            {
                self.graph1.alpha = 1
                self.graph2.alpha = 1
                self.graph3.alpha = 1
            }
            else if(graph.graphNum < 2)
            {
                self.graph1.alpha = 1
            }
            else if(graph.graphNum < 3)
            {
                self.graph2.alpha = 1
            }
            else
            {
                switch (order%10)
                {
                case 1:
                    self.graph1.alpha = 1
                case 2:
                    self.graph2.alpha = 1
                case 3:
                    self.graph3.alpha = 1
                default:
                    print("Bad number")
                }
            
                order = Int(order / 10)
            }
        
        }, completion: { (finished: Bool) -> Void in
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                
                if(graph.graphNum < 1)
                {
                    //nothing more to do
                }
                else if(graph.graphNum < 2)
                {
                    self.graph2.alpha = 1
                    self.graph3.alpha = 1
                }
                else if(graph.graphNum < 3)
                {
                    self.graph1.alpha = 1
                }
                else
                {
                    switch (order%10)
                    {
                    case 1:
                        self.graph1.alpha = 1
                    case 2:
                        self.graph2.alpha = 1
                    case 3:
                        self.graph3.alpha = 1
                    default:
                        print("Bad number")
                    }
                    
                    order = Int(order/10)
                }
                
                }, completion: { (finished: Bool) -> Void in
                    UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        
                        if(graph.graphNum < 1)
                        {
                            //nothing more to do
                        }
                        else if(graph.graphNum < 2)
                        {
                            //nothing more to do
                        }
                        else if(graph.graphNum < 3)
                        {
                            self.graph3.alpha = 1
                        }
                        else
                        {
                            switch order
                            {
                            case 1:
                                self.graph1.alpha = 1
                            case 2:
                                self.graph2.alpha = 1
                            case 3:
                                self.graph3.alpha = 1
                            default:
                                print("Bad number")
                            }
                        }
                        
                        }, completion: { (finished: Bool) -> Void in
                            print("all have faded in")
                    })
            })
        })
    }
    
    func displayGraphs()
    {
        // Draw graph
        graph1.setNeedsDisplay()
        graph2.setNeedsDisplay()
        graph3.setNeedsDisplay()
        
        // Labels
        if(graph.graphNum > 0)
        {
            switch graph.saveToInd
            {
            case 1:
                self.graphTitle1.text = "Graph \(graph.graphNum)"
                if(graph.graphNum > 1) {self.graphTitle3.text = "Graph \(graph.graphNum - 1)"}
                if(graph.graphNum > 2) {self.graphTitle2.text = "Graph \(graph.graphNum - 2)"}
            case 2:
                self.graphTitle2.text = "Graph \(graph.graphNum)"
                if(graph.graphNum > 1) {self.graphTitle1.text = "Graph \(graph.graphNum - 1)"}
                if(graph.graphNum > 2) {self.graphTitle3.text = "Graph \(graph.graphNum - 2)"}
            case 0:
                self.graphTitle3.text = "Graph \(graph.graphNum)"
                if(graph.graphNum > 1) {self.graphTitle2.text = "Graph \(graph.graphNum - 1)"}
                if(graph.graphNum > 2) {self.graphTitle1.text = "Graph \(graph.graphNum - 2)"}
            default:
                print("Index is WRONG")
            }
            
            graph1Max.text = "\(graph.g1Max)"
            graph1Min.text = "\(graph.g1Min)"
            graph2Max.text = "\(graph.g2Max)"
            graph2Min.text = "\(graph.g2Min)"
            graph3Max.text = "\(graph.g3Max)"
            graph3Min.text = "\(graph.g3Min)"
        }
        
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
            transitionManager.changeDir(TransitionManager.Direction.down)
        }
        
        let toViewController = segue.destinationViewController
        // instead of using the default transition animation, we'll ask
        // the segue to use our custom TransitionManager object to manage the transition animation
        toViewController.transitioningDelegate = transitionManager
        
    }
}
