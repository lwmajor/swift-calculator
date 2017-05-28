//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Lloyd Major on 21/05/2017.
//  Copyright © 2017 Lloyd Major. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    var lastOperation: String?
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unary(sqrt),
        "cos": Operation.unary(cos),
        "sin": Operation.unary(sin),
        "tan": Operation.unary(tan),
        "x²": Operation.unary({$0 * $0}),
        "±": Operation.unary({ -$0 }),
        "×": Operation.binary(*),
        "÷": Operation.binary(/),
        "+": Operation.binary(+),
        "−": Operation.binary(-),
        "=": Operation.equals,
        "C": Operation.clear
    ]
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private enum Operation {
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case equals
        case clear
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case.unary(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binary(let function):
                if accumulator != nil {
                    performPendingBinaryOperation()
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            case .clear:
                accumulator = nil
                pendingBinaryOperation = nil
            }
        }
    }
    
    private mutating func performPendingBinaryOperation()
    {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation?.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    private var accumulator: Double?
    
    var result: Double? {
        get {
            return accumulator
        }
    }
}
