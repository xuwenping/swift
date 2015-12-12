//
//  ViewController.swift
//  BullsEye
//
//  Created by devinxu on 7/19/15.
//  Copyright (c) 2015 devinxu. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
    var currentValue: Int = 0;
    var targetValue: Int = 0;
    var score = 0;
    var round = 0

    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var targetLabel: UILabel!
    
    @IBOutlet weak var scoreValueLabel: UILabel!
    
    @IBOutlet weak var roundValueLabel: UILabel!
    
    func startNewRound() {
        round += 1
        currentValue = 50;
        targetValue = 1 + Int(arc4random_uniform(100));
        
        slider.value = Float(currentValue);
    }
    
    func updateLabels() {
        targetLabel.text = "\(targetValue)" //String(targetValue);
        scoreValueLabel.text = String(score)
        roundValueLabel.text = String(round)
    }
    
    func startNewGame() {
        score = 0
        round = 0
        
        startNewRound()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let thumbImageNormal = UIImage(named: "SliderThumb-Normal");
        slider.setThumbImage(thumbImageNormal, forState: .Normal)
        
        let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted");
        slider.setThumbImage(thumbImageHighlighted, forState: .Highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        if let trackLeftImage = UIImage(named: "SliderTrackLeft") {
            let trackLeftResizable = trackLeftImage.resizableImageWithCapInsets(insets)
            slider.setMinimumTrackImage(trackLeftResizable, forState: .Normal)
        }
        if let trackRightImage = UIImage(named: "SliderTrackRight") {
            let trackRightResizable = trackRightImage.resizableImageWithCapInsets(insets)
            slider.setMaximumTrackImage(trackRightResizable, forState: .Normal)
        }
        
        startNewRound();
        
        updateLabels();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAlert() {
        
        let difference = abs(currentValue - targetValue)
        var points = 100 - difference
        
        
        var title: String
        if difference == 0 {
            title = "Perfect"
            points += 100
            
        }
        else if difference < 5 {
            title = "You almost had it!"
            if difference == 1 {
                points += 50
            }
        }
        else if difference < 10 {
            title = "Pretty good!"
        }
        else {
            title = "Not even close..."
        }
        
        score += points
        
        let message = "Your scored \(points) points"
        
        let alert = UIAlertController(title: title,
                                    message: message,
                             preferredStyle: .Alert);
        
        let action = UIAlertAction(title: "OK",
                                   style: .Default,
                                 handler: {
                                            action in
                                            self.startNewRound()
                                            self.updateLabels()
                                          });
        
        alert.addAction(action);
        
        presentViewController(alert, animated: true, completion: nil);
    }
    
    @IBAction func sliderMoved(slider: UISlider) {
        //println("The value of the slider is now: \(lroundf(slider.value))")
        currentValue = lroundf(slider.value)
    }
    
    @IBAction func startOver(sender: AnyObject) {
        startNewGame()
        
        updateLabels()
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        view.layer.addAnimation(transition, forKey: nil)
    }
}

