//
//  HistoryViewController.swift
//  Psychology
//
//  Created by devinxu on 3/30/16.
//  Copyright © 2016 devinxu. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    @IBOutlet weak var historyTextView: UITextView! {
        didSet {
            historyTextView.text = text
        }
    }
    
    var text: String = "" {
        didSet {
            historyTextView?.text = text
        }
    }
    
    
    override var preferredContentSize: CGSize {
        get {
            if historyTextView != nil && presentingViewController != nil {
                return historyTextView.sizeThatFits(presentingViewController!.view.bounds.size)
            }
            else {
                return super.preferredContentSize
            }

        }
        set {
            super.preferredContentSize = newValue
        }
    }
}
