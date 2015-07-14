//
//  ViewController.swift
//  ReactivePractice1
//
//  Created by Young Hoo Kim on 7/13/15.
//  Copyright (c) 2015 Young Hoo Kim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.rac_textSignal().subscribeNext { (x) -> Void in
            println(x)
        }
        
        let textSignal = self.textField.rac_textSignal().map { (x) -> AnyObject! in
            NSNumber(bool: ((x as? NSString) ?? "").rangeOfString("@").location != NSNotFound)
        } //NSNumber (boolean)
        
        let colorSignal = textSignal.map { x in
            ((x as? NSNumber)?.boolValue ?? false) ? UIColor.greenColor() : UIColor.redColor()
        } // UICOlor
        
        //textSignal ~> RAC(button, "enabled")
        colorSignal ~> RAC(textField, "textColor")
        
        let passwordSignal = self.passwordField.rac_textSignal().map { x in
            NSNumber(bool: (x as? NSString ?? "").length > 4)
        } //NSNumber
        
        let formValidSignal =  RACSignal.combineLatest([textSignal, passwordSignal]).map {
            let tuple = $0 as! RACTuple
            let bools = tuple.allObjects() as! [Bool]
            return NSNumber(bool: bools[0] == true && bools[1] == true)
        }
        formValidSignal ~> RAC(signInButton, "enabled")
        
        button.rac_command = RACCommand(enabled: textSignal, signalBlock: { (x) -> RACSignal! in
            println("pressed")
            return RACSignal.empty()
        })
    }
}
















