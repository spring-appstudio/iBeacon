//
//  RCSBeaconController.swift
//  iBeaconTest
//
//  Created by Ryan C. Spring on 10.12.14.
//  Copyright (c) 2014 Spring-Appstudio. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

let SAS_APP_STATE_CHANGE_NOTIFICATION = "SAS_BEACON_STATE_UPDATE"
let SAS_ADVERTIZING_CHANGE_NOTIFICATION = "SAS_ADVERTIZING_STATE_UPDATE"

class RCSBeaconController: NSObject, CBPeripheralManagerDelegate  {

    var peripheralManager : CBPeripheralManager?
    
    func startAdvertising() {
        let beaconID = NSUUID(UUIDString: "89388520-62C6-4F9B-A379-DF853060E5A7")
        let beaconRegion = CLBeaconRegion(proximityUUID: beaconID, identifier: "de.spring-appstudio.test")
        
        let dict  = beaconRegion.peripheralDataWithMeasuredPower(nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        peripheralManager!.startAdvertising(dict)
        println("Started advertising \(dict)")

    
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        println("state update on \(peripheral)")
        println("Have state \(peripheral.state.rawValue)")
        
        
        NSNotificationCenter.defaultCenter().postNotificationName(SAS_APP_STATE_CHANGE_NOTIFICATION, object: peripheral)
    }
    
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager!, error: NSError!) {
        println("Started advertising")
        
        NSNotificationCenter.defaultCenter().postNotificationName(SAS_ADVERTIZING_CHANGE_NOTIFICATION, object:peripheralManager)
        
    }

   
}
