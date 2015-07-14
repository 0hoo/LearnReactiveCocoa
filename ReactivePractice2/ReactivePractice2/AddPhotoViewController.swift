//
//  AddPhotoViewController.swift
//  ReactivePractice2
//
//  Created by Young Hoo Kim on 7/14/15.
//  Copyright (c) 2015 Young Hoo Kim. All rights reserved.
//

import UIKit

class AddPhotoViewController: UIViewController {
    
    let subject: RACReplaySubject
    let photo: PhotoModel = PhotoModel()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(subject: RACReplaySubject) {
        self.subject = subject
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        title = "Add Photo"
        
        view.backgroundColor = UIColor.whiteColor()
        
        let textField = UITextField(frame: CGRectMake(10, 96, 200, 30))
        textField.backgroundColor = UIColor.lightGrayColor()
        textField.textColor = UIColor.blackColor()
        view.addSubview(textField)
        
        let textLengthSignal = textField.rac_textSignal().map { x in
            NSNumber(bool: ((x as? NSString) ?? "").length > 0)
        }
        
        textField.rac_textSignal() ~> RAC(photo, "photoName")
        
        let button = UIButton(frame: CGRectMake(10, 150, 90, 35))
        button.setTitle("Save", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.blackColor()
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Disabled)
        button.rac_command = RACCommand(enabled: textLengthSignal, signalBlock: { [weak self] (x) -> RACSignal! in
            self?.subject.sendNext(self?.photo)
            self?.dismissViewControllerAnimated(true, completion: { () -> Void in
                self?.subject.sendCompleted()
            })
            return RACSignal.empty()
        })
        view.addSubview(button)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Done, target: self, action: Selector("close"))
    }
    
    func close() {
        self.dismissViewControllerAnimated(true, completion: { [weak self] () -> Void in
            self?.subject.sendCompleted()
        })
    }
}