//
//  ViewController.swift
//  iBeaconTest
//
//  Created by Ryan C. Spring on 12/7/14.
//  Copyright (c) 2014 Spring-Appstudio. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    enum listenSendState {
        case RCSBeaconSending,RCSBeaconReceiving
    }
    
    
    enum RCSButtonState {
        case RCSButtonStateStart,RCSButtonStateStop
    }
    
    
    var buttonState : RCSButtonState = RCSButtonState.RCSButtonStateStart
    var beaconController : RCSBeaconController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startButton.enabled = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stateNotification:", name: SAS_BEACON_CHANGE_NOTIFICATION, object: nil)
    
        beaconController = RCSBeaconController()
        beaconController?.setup()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateUI(bState : RCSBeaconState)->Void {
        
        switch(bState) {
        case .RCSBeaconNotAvailable:
            stateLabel.text = "Not Available"
            self.startButton.enabled = true
        case .RCSBeaconAvailable:
            stateLabel.text = "Available"
            self.startButton.enabled = true
            startButton.setTitle("Start", forState: UIControlState.Normal)
        case .RCSBeaconAdvertising:
            stateLabel.text = "Advertising"
            self.startButton.enabled = true
            startButton.setTitle("Stop", forState: UIControlState.Normal)
        case .RCSBeaconSearching:
            stateLabel.text = "Searching"
            self.startButton.enabled = true
            startButton.setTitle("Stop", forState: UIControlState.Normal)
        }
    }
        
    
    
    func stateNotification(notification : NSNotification)->Void {
    
        if let beaconObject = notification.object as? RCSBeaconController {
            updateUI(beaconObject.beaconState)
        }
       
    }

    @IBAction func segmentClicked(sender: AnyObject) {
        if let segControl = sender as? UISegmentedControl {
      
            if((segControl.selectedSegmentIndex == 1)&&(beaconController?.beaconState == RCSBeaconState.RCSBeaconAdvertising)) {
                beaconController?.stopAdvertising()
            }
            
            if((segControl.selectedSegmentIndex == 1)&&(beaconController?.beaconState == RCSBeaconState.RCSBeaconSearching)) {
                beaconController?.stopListening()
            }
            
        }
    }
    
    
    @IBAction func startButtonPushed(sender: AnyObject) {
        let button : UIButton = sender as UIButton
        
        switch(segmentedControl.selectedSegmentIndex) {
        case 0:
            if (beaconController?.beaconState == RCSBeaconState.RCSBeaconAvailable) {
                beaconController?.startAdvertising()
                buttonState = RCSButtonState.RCSButtonStateStop
            }
            else {
                beaconController?.stopAdvertising()
                buttonState = RCSButtonState.RCSButtonStateStart
            }
            
        case 1:
            if (beaconController?.beaconState == RCSBeaconState.RCSBeaconAvailable) {
                beaconController?.startListening()
                buttonState = RCSButtonState.RCSButtonStateStop
            }
            else {
                beaconController?.stopListening()
                buttonState = RCSButtonState.RCSButtonStateStart
            }
        default:
            println("Hey there")
        }
    }
}

