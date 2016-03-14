//
//  CalculateBrain.swift
//  Calculate
//
//  Created by devinxu on 2/28/16.
//  Copyright © 2016 devinxu. All rights reserved.
//

import Foundation

class CalculateBrain {
    private enum Op: CustomStringConvertible
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case Variable(String)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .Variable(let symbol):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String: Op]()
    
    var variableValues = [String: Double]()
    
    var description: String {
        var (result, ops) = ("", opStack)
        repeat {
            var current: String?
            (current, ops) = description(ops)
            result = current == "" ? current! : "\(current!), \(result)"
        } while ops.count > 0
        
        return result
    }
    
    private func description(ops: [Op]) -> (result: String?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return ("\(operand)", remainingOps)
            case .UnaryOperation(let symbol, _):
                let operandEvaluation = description(remainingOps)
                return ("\(symbol)(\(operandEvaluation.result!))", operandEvaluation.remainingOps)
            case .BinaryOperation(let symbol, _):
                let op1Evaluation = description(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = description(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return ("(\(operand1)\(symbol)\(operand2))", op2Evaluation.remainingOps)
                    }
                }
            case .Variable(let symbol):
                return ("\(variableValues["\(symbol)"])", remainingOps)
            }
        }
        
        return ("?", ops)
    }
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        knownOps["+"] = Op.BinaryOperation("+") {$0 + $1}
        knownOps["−"] = Op.BinaryOperation("−") {$1 - $0}
        knownOps["×"] = Op.BinaryOperation("×") {$0 * $1}
        knownOps["÷"] = Op.BinaryOperation("÷") {$1 / $0}
        knownOps["√"] = Op.UnaryOperation("√") {sqrt($0)}
        knownOps["sin"] = Op.UnaryOperation("sin") {sin($0)}
        knownOps["cos"] = Op.UnaryOperation("cos") {cos($0)}
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .Variable(let symbol):
                return (variableValues["\(symbol)"], remainingOps)
            }
            
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
        
        return evaluate()
    }
    
    func performOperation(operation: String) -> Double? {
        if let op = knownOps[operation] {
            opStack.append(op)
        }
        
        return evaluate()
    }
    
    func showHistory() -> String {
        return "\(opStack)"
    }
}
