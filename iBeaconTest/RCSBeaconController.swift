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
    case RCSBeaconNotAvailable,RCSBeaconAvailable,RCSBeaconAdvertising,RCSBeaconSearching
}


class RCSBeaconController: NSObject, CBPeripheralManagerDelegate  {

    
    let UUIDString = "89388520-62C6-4F9B-A379-DF853060E5A7"
    let APPString = "de.spring-appstudio.test"
    
    var peripheralManager : CBPeripheralManager?
    var beaconState : RCSBeaconState = RCSBeaconState.RCSBeaconNotAvailable
    
    func setup()->Void {
     
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)

    }
    
    func startAdvertising() {
        if(beaconState != RCSBeaconState.RCSBeaconAvailable) {
            return
        }
        
        let beaconID = NSUUID(UUIDString: UUIDString)
        let beaconRegion = CLBeaconRegion(proximityUUID: beaconID, identifier: APPString)
        
        let dict  = beaconRegion.peripheralDataWithMeasuredPower(nil)
        
        peripheralManager!.startAdvertising(dict)
    }
    

    func stopAdvertising() {
        if(beaconState != RCSBeaconState.RCSBeaconAdvertising) {
            return
        }
        
        
        peripheralManager!.stopAdvertising()
        beaconState = RCSBeaconState.RCSBeaconAvailable
        
        NSNotificationCenter.defaultCenter().postNotificationName(SAS_APP_STATE_CHANGE_NOTIFICATION, object:self)
    }
    
    func startListening() {
        
        if(beaconState != RCSBeaconState.RCSBeaconAvailable) {
            return
        }
        println("Started listening")
    }
    
    func stopListening() {
        if(beaconState != RCSBeaconState.RCSBeaconSearching) {
            return
        }
        
        println("Stopped Listening")
    }
    
    override func delete(sender: AnyObject?) {
        peripheralManager!.stopAdvertising()
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        
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
        beaconState = RCSBeaconState.RCSBeaconAdvertising
        NSNotificationCenter.defaultCenter().postNotificationName(SAS_APP_STATE_CHANGE_NOTIFICATION, object:self)
    }

   
}
