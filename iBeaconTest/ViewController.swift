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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stateNotification:", name: SAS_APP_STATE_CHANGE_NOTIFICATION, object: nil)
    
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
            self.startButton.enabled = false
        case .RCSBeaconAvailable:
            stateLabel.text = "Available"
            self.startButton.enabled = true
        case .RCSBeaconAdvertising:
            stateLabel.text = "Advertising"
            self.startButton.enabled = true
        }
    }
        
    
    
    func stateNotification(notification : NSNotification)->Void {
        println("Notification \(notification)")
        
        if let beaconObject = notification.object as? RCSBeaconController {
            updateUI(beaconObject.beaconState)
        }
       
    }

    @IBAction func segmentClicked(sender: AnyObject) {
        if let segControl = sender as? UISegmentedControl {
            println("Segment changed \(segControl.selectedSegmentIndex)")
        }
    }
    
    
    @IBAction func startButtonPushed(sender: AnyObject) {
        let button : UIButton = sender as UIButton
        if(buttonState == RCSButtonState.RCSButtonStateStart) {
            beaconController?.startAdvertising()
            buttonState = RCSButtonState.RCSButtonStateStop
            button.setTitle("Stop", forState: UIControlState.Normal)
        }
        else {
            beaconController?.stopAdvertising()
            buttonState = RCSButtonState.RCSButtonStateStart
            button.setTitle("Start", forState: UIControlState.Normal)
        }
    }

}

