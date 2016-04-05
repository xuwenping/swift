//
//  HistoryHappinessViewController.swift
//  Psychology
//
//  Created by devinxu on 3/31/16.
//  Copyright © 2016 devinxu. All rights reserved.
//

import UIKit

class HistoryHappinessViewController: HappinessViewController, UIPopoverPresentationControllerDelegate {
    
    override var happiness: Int {
        didSet {
            history += [happiness]
        }
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var history: [Int] {
        get {
            return defaults.objectForKey(History.DefaultsKey) as? [Int] ?? []
        }
        set {
            defaults.setObject(newValue, forKey: History.DefaultsKey)
        }
    }
    
    private struct History {
        static let SegueIdentifier = "show history"
        static let DefaultsKey = "HistoryHappinessViewController.history"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case History.SegueIdentifier:
                if let vc = segue.destinationViewController as? HistoryViewController {
                    vc.text = "\(history)"
                    if let ppc = vc.popoverPresentationController {
                        ppc.delegate = self
                    }
                }
            default: break
            }
        }
    }
    
    // MARK: delegate
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}