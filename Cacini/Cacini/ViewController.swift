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
        if let ivc = segue.destinationViewController as? ImageViewContorller {
            if let identifier = segue.identifier {
                switch identifier {
                case "Woman":
                    ivc.imageURL = DemoURL.Character.womanURL
                case "Man":
                    ivc.imageURL = DemoURL.Character.manURL
                case "Child":
                    ivc.imageURL = DemoURL.Character.childURL
                default:
                    break
                }
            }
        }
    }
}

