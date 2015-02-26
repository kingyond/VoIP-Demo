//
//  ViewController.swift
//  VoIP-Demo
//
//  Created by Stefan Natchev on 2/5/15.
//  Copyright (c) 2015 ZeroPush. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var payloadLabel: UILabel!

    @IBAction func requestButtonPressed(sender: UIButton) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.registerVoipNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

