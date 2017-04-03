//
//  FridgeViewController.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /03/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class FridgeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("In Fridge VC")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.title = Constants.Fridges.View.title
    }
    
    deinit {
        print("Out fridge VC")
    }
}
