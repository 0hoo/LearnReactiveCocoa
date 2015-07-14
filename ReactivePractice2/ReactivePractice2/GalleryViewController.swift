//
//  GalleryViewController.swift
//  ReactivePractice2
//
//  Created by Young Hoo Kim on 7/14/15.
//  Copyright (c) 2015 Young Hoo Kim. All rights reserved.
//

import UIKit

class GalleryFlowLayout: UICollectionViewFlowLayout {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        
        self.itemSize = CGSizeMake(172, 172)
        self.minimumInteritemSpacing = 10
        self.minimumLineSpacing = 10
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
    }
}

class GalleryViewController: UICollectionViewController {
    dynamic var photos: [PhotoModel] = []
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        let flowLayout = GalleryFlowLayout()
        super.init(collectionViewLayout: flowLayout)
    }
    
    override func viewDidLoad() {
        title = "Popular on 500px"
        collectionView?.registerClass(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier())
        
        RACObserve(self, "photos").subscribeNext { [weak self] _ in self?.collectionView!.reloadData() }
        
        loadPopularPhotos()
    }
    
    func loadPopularPhotos() {
        SVProgressHUD.show()
        PhotoImpoter.importPhotos().subscribeNextAs { [weak self] (x: [PhotoModel]) in
            SVProgressHUD.dismiss()
            println("Loaded: \(x.count)")
            self?.photos = x
        }
    }
    
    
    
    override func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.navigationController?.pushViewController(
            PhotoViewController(photoModel: self.photos[indexPath.item]),
            animated: true)
    }
    
    
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCell.reuseIdentifier(), forIndexPath: indexPath) as? PhotoCell {
            cell.setPhotoModel(photos[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}
