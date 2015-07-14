//
//  PhotoCell.swift
//  ReactivePractice2
//
//  Created by Young Hoo Kim on 7/14/15.
//  Copyright (c) 2015 Young Hoo Kim. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    let imageView: UIImageView
    var subscription: RACDisposable!
    
    class func reuseIdentifier() -> String {
        return "PhotoCellIdentifier"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        imageView = UIImageView(frame: CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)))
        imageView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.darkGrayColor()
        self.contentView.addSubview(imageView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.subscription?.dispose()
        self.subscription = nil
    }
    
    func setPhotoModel(model: PhotoModel) {
        
    }
}