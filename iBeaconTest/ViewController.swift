//
//  ViewController.swift
//  iBeaconTest
//
//  Created by Ryan C. Spring on 12/7/14.
//  Copyright (c) 2014 Spring-Appstudio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    enum buttonState {
        case ButtonStateStart,ButtonStateStop
    }
    
    var state : buttonState = buttonState.ButtonStateStart
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stateNotification", name: SAS_APP_STATE_CHANGE_NOTIFICATION, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "advertisingNotification", name: SAS_ADVERTIZING_CHANGE_NOTIFICATION, object: nil)

        updateUI()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateUI()->Void {
        if let manager = sharedBTPeripheralManager {
            switch(manager.state) {
            case .PoweredOff:
                stateLabel.text = "Powered Off"
            case .PoweredOn:
                stateLabel.text = "Powered On"
            case .Resetting:
                stateLabel.text = "Reseting"
            case .Unauthorized:
                stateLabel.text = "Unauthorized"
            case .Unknown:
                stateLabel.text = "Unknown"
            case .Unsupported:
                stateLabel.text = "Unsupported"
            }
        }
        else {
            stateLabel.text = "Unknown"
        }
        
    }
    
    func stateNotification()->Void {
        println("Notification")
        //updateUI()
    }

    
    
    func advertizingNotification()->Void {
        println("Advertising Notification")
        stateLabel.text = "Advertising"
    }
    
    @IBAction func startButtonPushed(sender: AnyObject) {
        let button : UIButton = sender as UIButton
        if(state == buttonState.ButtonStateStart) {
            button.setTitle("Stop", forState: UIControlState.Normal)
        }
        else {
            button.setTitle("Start", forState: UIControlState.Normal)
        }
    }

}

