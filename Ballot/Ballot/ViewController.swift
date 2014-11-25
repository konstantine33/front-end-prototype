//
//  ViewController.swift
//  Ballot
//
//  Created by Tim Jenkins on 11/24/14.
//  Copyright (c) 2014 ballot-app. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let chosenMargin: CGFloat = 100
    var xFromCenter: CGFloat = 0
    let rectWidth: CGFloat = 200
    let rectHeight: CGFloat = 200
    var i = 0
    var ballotArray:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let path = NSBundle.mainBundle().pathForResource("ballots", ofType: "plist")
        ballotArray = NSArray(contentsOfFile: path!)!
        
        var label: UILabel = UILabel(frame: CGRectMake(self.view.bounds.width / 2 - rectWidth / 2, self.view.bounds.height / 2 - rectHeight / 2, rectWidth, rectHeight))
        
        label.layer.borderColor = UIColor.blackColor().CGColor
        label.layer.borderWidth = 1
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        label.text = (ballotArray[i] as String)
        i++
        
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
        
        var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        label.addGestureRecognizer(gesture)
        
        label.userInteractionEnabled = true
        
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translationInView(self.view)
        var label = gesture.view!
        var choiceMade = ""
        
        xFromCenter += translation.x
        
        var scale = 1 - abs(xFromCenter) / 600
        scale = max(scale, 0.9)
        
        label.center = CGPoint(x: label.center.x + translation.x, y: label.center.y + translation.y)
        
        var rotation:CGAffineTransform = CGAffineTransformMakeRotation(xFromCenter/500)
        var stretch:CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
        
        label.transform = stretch
        
        if label.center.x < chosenMargin {
            
            choiceMade = "no"
            
        } else if label.center.x > self.view.bounds.width - chosenMargin {
            
            choiceMade = "yes"
            
        } else {
            
            choiceMade = "undecided"
        }
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            println("Voted \(choiceMade)")
            label.center = CGPointMake(self.view.bounds.width / 2, self.view.bounds.height / 2)
            scale = 1
            rotation = CGAffineTransformMakeRotation(0)
            stretch = CGAffineTransformScale(rotation, scale, scale)
            label.transform = stretch
            xFromCenter = 0
            
            if choiceMade != "undecided" {
                label.removeFromSuperview()
                
                var label: UILabel = UILabel(frame: CGRectMake(self.view.bounds.width / 2 - rectWidth / 2, self.view.bounds.height / 2 - rectHeight / 2, rectWidth, rectHeight))
                
                label.layer.borderColor = UIColor.blackColor().CGColor
                label.layer.borderWidth = 1
                label.numberOfLines = 0
                label.lineBreakMode = NSLineBreakMode.ByWordWrapping
                
                label.text = (ballotArray[i] as String)
                i++
                
                if (i > ballotArray.count - 1) {
                    i = 0
                }
                
                label.textAlignment = NSTextAlignment.Center
                self.view.addSubview(label)
                
                var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
                label.addGestureRecognizer(gesture)
                
                label.userInteractionEnabled = true
                
                choiceMade = "undecided"
            }
        }
        
        gesture.setTranslation(CGPointZero, inView: self.view)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
