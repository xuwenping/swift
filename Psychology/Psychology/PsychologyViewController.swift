//
//  ViewController.swift
//  Psychology
//
//  Created by devinxu on 3/28/16.
//  Copyright © 2016 devinxu. All rights reserved.
//

import UIKit

class PsychologyViewController: UIViewController {

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        if let nvc = destination as? UINavigationController {
            destination = nvc.visibleViewController!
        }
        
        if let hvc = destination as? HappinessViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case "Dancing Tree":
                    hvc.happiness = 100
                case "Dirty water":
                    hvc.happiness = 0
                case "afternoor":
                    hvc.happiness = 50
                default:
                    hvc.happiness = 50
                }
            }
        }
        
    }
    
}

