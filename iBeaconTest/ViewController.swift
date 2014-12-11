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
    enum buttonState {
        case ButtonStateStart,ButtonStateStop
    }
    
    var state : buttonState = buttonState.ButtonStateStart
    var beaconController : RCSBeaconController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
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
        case .RCSBeaconAvailable:
            stateLabel.text = "Available"
        case .RCSBeaconAdvertising:
            stateLabel.text = "Advertising"
        }
    }
        
    
    
    func stateNotification(notification : NSNotification)->Void {
        println("Notification \(notification)")
        
        if let beaconObject = notification.object as? RCSBeaconController {
            updateUI(beaconObject.beaconState)
        }
       
    }

    
    @IBAction func startButtonPushed(sender: AnyObject) {
        let button : UIButton = sender as UIButton
        if(state == buttonState.ButtonStateStart) {
            beaconController?.startAdvertising()
            state = buttonState.ButtonStateStop
            button.setTitle("Stop", forState: UIControlState.Normal)
        }
        else {
            beaconController?.stopAdvertising()
            state = buttonState.ButtonStateStart
            button.setTitle("Start", forState: UIControlState.Normal)
        }
    }

}

