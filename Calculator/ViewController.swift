//
//  ViewController.swift
//  Calculator
//
//  Created by Lloyd Major on 21/05/2017.
//  Copyright © 2017 Lloyd Major. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var userIsInTheMiddleOfTyping = false
    
    @IBOutlet weak var display: UILabel!
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
    }
    
    private var brain = CalculatorBrain()
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if (!(display.text!.contains(".") && digit == "."))
        {
            if userIsInTheMiddleOfTyping
            {
                display.text! += digit
            }
            else {
                display.text = digit == "." ? "0." : digit
                userIsInTheMiddleOfTyping = true
            }
        }
    }
}
