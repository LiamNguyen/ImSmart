//
//  AirConditionerViewController.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /03/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class AirConditionerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("In Air Con VC")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.title = Constants.AirConditioner.View.title
    }
    
    deinit {
        print("Out Air Con VC")
    }
}
