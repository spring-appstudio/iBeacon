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
enum RCSBeaconState {
    case RCSBeaconNotAvailable,RCSBeaconAvailable,RCSBeaconAdvertising
}


class RCSBeaconController: NSObject, CBPeripheralManagerDelegate  {

    var peripheralManager : CBPeripheralManager?
    var beaconState : RCSBeaconState = RCSBeaconState.RCSBeaconNotAvailable
    
    func setup()->Void {
     
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)

    }
    
    func startAdvertising() {
        let beaconID = NSUUID(UUIDString: "89388520-62C6-4F9B-A379-DF853060E5A7")
        let beaconRegion = CLBeaconRegion(proximityUUID: beaconID, identifier: "de.spring-appstudio.test")
        
        let dict  = beaconRegion.peripheralDataWithMeasuredPower(nil)
        
        peripheralManager!.startAdvertising(dict)
        println("Started advertising")

    
    }
    
    
    func stopAdvertising() {
        peripheralManager!.stopAdvertising()
    }
    
    override func delete(sender: AnyObject?) {
        peripheralManager!.stopAdvertising()
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        println("state update on \(peripheral)")
        println("Have state \(peripheral.state.rawValue)")
       // var beaconState : RCSBeaconState
        
        switch(peripheral.state) {
        case .PoweredOff:
            beaconState = RCSBeaconState.RCSBeaconNotAvailable
        case .PoweredOn:
            beaconState = RCSBeaconState.RCSBeaconAvailable
        case .Resetting:
            beaconState = RCSBeaconState.RCSBeaconNotAvailable
        case .Unauthorized:
            beaconState = RCSBeaconState.RCSBeaconNotAvailable
        case .Unknown:
            beaconState = RCSBeaconState.RCSBeaconNotAvailable
        case .Unsupported:
            beaconState = RCSBeaconState.RCSBeaconNotAvailable
        }
        
        
        NSNotificationCenter.defaultCenter().postNotificationName(SAS_APP_STATE_CHANGE_NOTIFICATION, object:self)
    }
    
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager!, error: NSError!) {
        println("Started advertising")
        beaconState = RCSBeaconState.RCSBeaconAdvertising
        
        NSNotificationCenter.defaultCenter().postNotificationName(SAS_APP_STATE_CHANGE_NOTIFICATION, object:self)
        
    }

   
}
