//
//  AppDelegate.swift
//  QQ音乐
//
//  Created by LHB on 16/4/5.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var displayLink: CADisplayLink?
    
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }



    func applicationDidEnterBackground(application: UIApplication) {
       
    }
    
    func applicationWillResignActive(application: UIApplication) {
//        addDisPlayLink()
    }
    


    func applicationWillEnterForeground(application: UIApplication) {
//       removeDisPlayLink()
    }

 
}



extension AppDelegate {
    
    func updateLockMessage() -> () {
        print("444")
//        QQMusicOperationTool.shareInstance.setUpLockMessage()
       
    }
    
    func addDisPlayLink() -> () {
        displayLink = CADisplayLink(target: self, selector: #selector(updateLockMessage))
        displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func removeDisPlayLink() -> () {
        displayLink?.invalidate()
        displayLink = nil
    }

}


