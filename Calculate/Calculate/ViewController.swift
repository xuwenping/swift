//
//  ViewController.swift
//  Calculate
//
//  Created by devinxu on 2/21/16.
//  Copyright © 2016 devinxu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingInput: Bool = false
    

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingInput {
            display.text = display.text! + digit
        }
        else {
            display.text = digit
            userIsInTheMiddleOfTypingInput = true
        }
    }
}

