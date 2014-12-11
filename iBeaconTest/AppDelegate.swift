//
//  AppDelegate.swift
//  iBeaconTest
//
//  Created by Ryan C. Spring on 12/7/14.
//  Copyright (c) 2014 Spring-Appstudio. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var beaconController : RCSBeaconController?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
//        let beaconID = NSUUID(UUIDString: "89388520-62C6-4F9B-A379-DF853060E5A7")
//        let beaconRegion = CLBeaconRegion(proximityUUID: beaconID, identifier: "de.spring-appstudio.test")
//        
//        let dict  = beaconRegion.peripheralDataWithMeasuredPower(nil)
//        sharedBTPeripheralManager = CBPeripheralManager(delegate: self, queue: nil)
//        sharedBTPeripheralManager!.startAdvertising(dict)
//        println("Started advertising \(dict)")
        
      //  beaconController = RCSBeaconController()
        //beaconController?.startAdvertising()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
//    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
//        println("state update on \(peripheral)")
//        println("Have state \(peripheral.state.rawValue)")
//        
//        
//        NSNotificationCenter.defaultCenter().postNotificationName(SAS_APP_STATE_CHANGE_NOTIFICATION, object: peripheral)
//    }
//    
//    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager!, error: NSError!) {
//        println("Started advertising")
//        
//        NSNotificationCenter.defaultCenter().postNotificationName(SAS_ADVERTIZING_CHANGE_NOTIFICATION, object: nil)
//        
//    }
    


}

