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
    
    var operandStack  = Array<Double>()
    @IBAction func enter() {
        userIsInTheMiddleOfTypingInput = false
        
        operandStack.append(displayValue)
        
        print("the operand stack value: \(operandStack)")
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingInput = false
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingInput {
            enter()
        }
        switch operation {
        case "+": performOperation {$0 + $1}
        case "−": performOperation {$1 - $0}
        case "×": performOperation {$0 * $1}
        case "÷": performOperation {$1 / $0}
        case "√": performOperation {sqrt($0)}

        default: break
        }
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

