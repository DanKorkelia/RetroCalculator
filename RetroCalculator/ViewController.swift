//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Dan Korkelia on 17/09/2017.
//  Copyright © 2017 Dan Korkelia. All rights reserved.
//

import UIKit
import AVFoundation

class CalculatorVC: UIViewController {
    
    @IBOutlet weak var outputLabel: UILabel!

    var btnSound: AVAudioPlayer!
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    
    }
    
    var currentOperation = Operation.Empty
    var runningNumber = ""
    var leftValueStr = ""
    var rightValueStr = ""
    var result = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //load sound file
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        outputLabel.text = "0"
    }

    @IBAction func pressClearBtn(_ sender: Any) {
         currentOperation = Operation.Empty
         runningNumber.removeAll()
         outputLabel.text = "0"
    }
    
    @IBAction func numberPressed(sender: UIButton) {
        playSound()
    
        runningNumber += "\(sender.tag)"
        outputLabel.text = runningNumber
    }
    
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(operation: Operation.Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject) {
         processOperation(operation: Operation.Multiply)
    }
    
    @IBAction func onSubstractPressed(sender: AnyObject) {
         processOperation(operation: Operation.Subtract)
    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
         processOperation(operation: Operation.Add)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject) {
           processOperation(operation: currentOperation)
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        btnSound.play()
    }
    
    func processOperation(operation: Operation) {
        if currentOperation != Operation.Empty {
            
            // a user selected an operator but then selected another operator without first entering a number
            if runningNumber != "" {
                rightValueStr = runningNumber
                runningNumber = ""
                
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValueStr)! * Double(rightValueStr)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValueStr)! / Double(rightValueStr)!)"
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValueStr)! - Double(rightValueStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValueStr)! + Double(rightValueStr)!)"
                }
                    leftValueStr = result
                    outputLabel.text = result
            }
            currentOperation = operation
        } else {
        // this is the first time an operator has been pressed
            leftValueStr = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }


}
