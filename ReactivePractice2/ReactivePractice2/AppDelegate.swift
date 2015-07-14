//
//  AppDelegate.swift
//  ReactivePractice2
//
//  Created by Young Hoo Kim on 7/14/15.
//  Copyright (c) 2015 Young Hoo Kim. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var apiHelper: PXAPIHelper!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let helper = PXHelper()
        apiHelper = helper.makePXAPIHelper()
        
        self.window =  UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: GalleryViewController())
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()

        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
}

