//
//  PhotoViewController.swift
//  ReactivePractice2
//
//  Created by Young Hoo Kim on 7/14/15.
//  Copyright (c) 2015 Young Hoo Kim. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    let photoModel: PhotoModel

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(photoModel: PhotoModel) {
        self.photoModel = photoModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.photoModel.photoName
        
        view.backgroundColor = UIColor.blackColor()
        
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        view.addSubview(imageView)
        
        let imageSignal = RACObserve(self.photoModel, "fullsizedData").map { x in
            SVProgressHUD.dismiss()
            if let data = x as? NSData {
                return UIImage(data: data)
            }
            return nil
        }
        imageSignal ~> RAC(imageView, "image")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        SVProgressHUD.show()
        PhotoImpoter.fetchPhotoDetails(photoModel).subscribeError({ (error) -> Void in
            SVProgressHUD.showErrorWithStatus("Error")
        })
    }
    
    
}
