
//  RCSBeaconController.swift
//  iBeaconTest
//
//  Created by Ryan C. Spring on 10.12.14.
//  Copyright (c) 2014 Spring-Appstudio. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

let RCS_BEACON_CONTROLLER_STATE_NOTIFICATION = "RCS_BEACON_CONTROLLER_STATE_NOTIFICATION"
let RCS_BEACON_EVENT_NOTIFICATION = "RCS_BEACON_EVENT_NOTICICATION"

let RCS_BEACON_EVENT_TIMESTAMP = "RCS_BEACON_EVENT_TIMESTAMP"
let RCS_BEACON_EVENT_TYPE = "RCS_BEACON_EVENT_TYPE"

enum RCSBeaconState {
    case RCSBeaconNotAvailable,RCSBeaconAvailable,RCSBeaconAdvertising,RCSBeaconSearching
}

enum RCSBeaconEvent : String {
    case RCSBeaconDetected = "RCSBeaconDetected"
    case RCSBeaconLost = "RCSBeaconLost"
}


class RCSBeaconController: NSObject, CBPeripheralManagerDelegate,CLLocationManagerDelegate  {

    
    let UUIDString = "89388520-62C6-4F9B-A379-DF853060E5A7"
    let APPString = "beaconTest"
    
    var peripheralManager : CBPeripheralManager?
    var locationManager : CLLocationManager?
    var beaconRegion : CLBeaconRegion?
    var beaconState : RCSBeaconState = RCSBeaconState.RCSBeaconNotAvailable
    
    func setup()->Void {
     
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
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
        notifyStateChange()
    }
    
    func startListening() {
        
        if(beaconState != RCSBeaconState.RCSBeaconAvailable) {
            return
        }
        
        beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: UUIDString), identifier: APPString)
        
        locationManager?.startMonitoringForRegion(beaconRegion)

        beaconState = RCSBeaconState.RCSBeaconSearching
        notifyStateChange()
    }
    
    func stopListening() {
        if(beaconState != RCSBeaconState.RCSBeaconSearching) {
            return
        }
        
        beaconState = RCSBeaconState.RCSBeaconAvailable
        
        locationManager?.stopRangingBeaconsInRegion(beaconRegion)
        
        notifyStateChange()
    }
    
    private func notifyStateChange()->Void {
        NSNotificationCenter.defaultCenter().postNotificationName(RCS_BEACON_CONTROLLER_STATE_NOTIFICATION, object:self)
    }
    
    
    private func notifyBeaconEvent(event : RCSBeaconEvent)->Void {
        
        let eventDict : Dictionary<NSObject,AnyObject> = [RCS_BEACON_EVENT_TIMESTAMP : NSDate(),RCS_BEACON_EVENT_TYPE:event.rawValue]
        
        NSNotificationCenter.defaultCenter().postNotificationName(RCS_BEACON_EVENT_NOTIFICATION, object: self, userInfo: eventDict
        )
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
        
        
        notifyStateChange()
    }
    
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager!, error: NSError!) {
        beaconState = RCSBeaconState.RCSBeaconAdvertising
        notifyStateChange()
    }
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        println("Started monitoring \(region.description)")
    }

    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("Entered region")
        
        notifyBeaconEvent(.RCSBeaconDetected)
        
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println("Exited region")
         notifyBeaconEvent(.RCSBeaconLost)
    }
    
    func locationManager(manager: CLLocationManager!, monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {
        println("Monitoring failed")
    }
    
   
}
