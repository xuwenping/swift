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
    
    var userIsInTheMiddleOfTypingInput = false
    
    var brain = CalculateBrain()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if digit.containsString(".") {
            if !display.text!.containsString(".") {
                display.text = display.text! + digit
            }
        }
        else
        {
            if userIsInTheMiddleOfTypingInput {
                display.text = display.text! + digit
            }
            else
            {
                display.text = digit
                userIsInTheMiddleOfTypingInput = true
            }
        }
    }
    
    var operandStack  = [Double]()
    @IBAction func enter() {
        userIsInTheMiddleOfTypingInput = false
        
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        }
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue!)"
            userIsInTheMiddleOfTypingInput = false
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        
        if userIsInTheMiddleOfTypingInput {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            }
            else {
                displayValue = nil
            }
        }
    }
    
    @IBAction func clearDisplay() {
        operandStack.removeAll()
        display.text = "0"
        userIsInTheMiddleOfTypingInput = false
        
        print("clear the stack value: \(operandStack)")
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
}

