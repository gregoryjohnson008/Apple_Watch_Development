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
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
        
            if(graph.graphNum < 1)
            {
                self.graph1.alpha = 1
                self.graph2.alpha = 1
                self.graph3.alpha = 1
            }
            else
            {
                self.graph1.alpha = 1
            }
        
        }, completion: { (finished: Bool) -> Void in
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                
                if(graph.graphNum < 2)
                {
                    self.graph2.alpha = 1
                    self.graph3.alpha = 1
                }
                else
                {
                    self.graph2.alpha = 1
                }
                
                }, completion: { (finished: Bool) -> Void in
                    UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        
                        self.graph3.alpha = 1
                        
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
            self.graphTitle1.text = graph.dates[0]!
            if(graph.graphNum > 1)
            {
                self.graphTitle2.text = graph.dates[1]!
                if(graph.graphNum > 2)
                {
                    self.graphTitle3.text = graph.dates[2]!
                }
            }
        }
        
        graph1Max.text = "\(graph.maxMin[0][0])"
        graph1Min.text = "\(graph.maxMin[0][1])"
        graph2Max.text = "\(graph.maxMin[1][0])"
        graph2Min.text = "\(graph.maxMin[1][1])"
        graph3Max.text = "\(graph.maxMin[2][0])"
        graph3Min.text = "\(graph.maxMin[2][1])"
        
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
