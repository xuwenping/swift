//
//  ViewController.swift
//  Cacini
//
//  Created by devinxu on 5/25/16.
//  Copyright © 2016 devinxu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        if let nvc = destination as? UINavigationController {
            destination = nvc.visibleViewController!
        }
        
        if let ivc = destination as? ImageViewContorller {
            if let identifier = segue.identifier {
                switch identifier {
                case "Woman":
                    ivc.imageURL = DemoURL.Character.womanURL
                    ivc.title = "woman"
                case "Man":
                    ivc.imageURL = DemoURL.Character.manURL
                    ivc.title = "man"
                case "Child":
                    ivc.imageURL = DemoURL.Character.childURL
                    ivc.title = "child"
                default:
                    break
                }
            }
        }
    }
}

