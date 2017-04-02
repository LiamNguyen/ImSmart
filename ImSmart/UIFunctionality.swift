//
//  UIFunctionality.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /01/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import UIKit

struct UIFunctionality {
    static func applyShadow(toView: AnyObject, withColor: UIColor) {
        toView.layer.shadowColor = withColor.cgColor
        toView.layer.shadowOffset = CGSize.zero
        toView.layer.shadowOpacity = 0.7
        toView.layer.shadowRadius = 10
    }
}
