//
//  PhotoModel.swift
//  ReactivePractice2
//
//  Created by Young Hoo Kim on 7/14/15.
//  Copyright (c) 2015 Young Hoo Kim. All rights reserved.
//

import Foundation

class PhotoModel: NSObject {
    var photoName: String!
    var identifier: NSNumber!
    var photographerName: String!
    var rating: String!

    var thumbnailURL: String!
    var fullsizedURL: String!

    dynamic var thumbnailData: NSData?
    dynamic var fullsizedData: NSData?
}

class PhotoImpoter: NSObject {
    
    class func photoURLRequest(photoModel: PhotoModel) -> NSURLRequest! {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            return appDelegate.apiHelper.urlRequestForPhotoID(photoModel.identifier.integerValue)
        }
        return nil
    }
    
    class func fetchPhotoDetails(photoModel: PhotoModel) -> RACSignal {
        let subject = RACReplaySubject()
        let request = photoURLRequest(photoModel)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if let result = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary, photo = result.objectForKey("photo") as? NSDictionary where data != nil {
                self.configurePhotoModel(photoModel, dictionary: photo)
                self.downloadFullSizedImageForPhotoModel(photoModel)
                subject.sendNext(photoModel)
                subject.sendCompleted()
            } else {
                subject.sendError(error)
            }
        }
        
        return subject
    }
    
    class func popularURLRequest() -> NSURLRequest! {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            return appDelegate.apiHelper.urlRequestForPhotoFeature(PXAPIHelperPhotoFeature.Popular, resultsPerPage: 100, page: 0, photoSizes: PXPhotoModelSize.Thumbnail, sortOrder: PXAPIHelperSortOrder.Rating, except: PXPhotoModelCategory.PXPhotoModelCategoryNude)
        }
        return nil
    }
    
    class func configurePhotoModel(model: PhotoModel, dictionary: NSDictionary) {
        model.photoName = dictionary.objectForKey("name") as? String
        model.identifier = dictionary.objectForKey("id") as? NSNumber
        model.photographerName = (dictionary.objectForKey("user") as? NSDictionary)?.objectForKey("username") as? String
        model.rating = dictionary.objectForKey("rating") as? String
        model.thumbnailURL = PhotoImpoter.urlForIamgeSize(3, array: dictionary.objectForKey("images") as! [NSDictionary])
        
        if dictionary.objectForKey("comments_count") != nil {
            model.fullsizedURL = PhotoImpoter.urlForIamgeSize(4, array: dictionary.objectForKey("images") as! [NSDictionary])
        }
    }
    
    class func downloadThumbnailForPhotoModel(model: PhotoModel) {
        download(model.thumbnailURL) { data in
            model.thumbnailData = data
        }
    }
    
    class func downloadFullSizedImageForPhotoModel(model: PhotoModel) {
        download(model.fullsizedURL) { data in
            model.fullsizedData = data
        }
    }
    
    class func download(urlString: String, completion: (NSData -> Void)) {
        if let url = NSURL(string: urlString) {
            NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: url), queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                completion(data)
            })
        }
    }
    
    class func urlForIamgeSize(size: Int, array: [NSDictionary]) -> String? {
        var urlString = array.filter({ (($0.objectForKey("size") as? Int) ?? -1) == size }).map({ $0.objectForKey("url") as! String }).first
        return urlString
    }
    
    class func importPhotos() -> RACReplaySubject {
        let subject = RACReplaySubject()
        return subject
    }
}