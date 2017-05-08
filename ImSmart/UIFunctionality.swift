//
//  UIFunctionality.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /01/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import UIKit
import Spruce

struct UIFunctionality {
    static func applyShadow(_ toView: AnyObject, withColor: UIColor) {
        toView.layer.shadowColor = withColor.cgColor
        toView.layer.shadowOffset = CGSize.zero
        toView.layer.shadowOpacity = 0.7
        toView.layer.shadowRadius = 10
    }
    
    static func applyShakyAnimation(_ elementToBeShake: AnyObject, duration: Float, repeatCount: Float = .infinity) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = CFTimeInterval(duration)
        animation.repeatCount = repeatCount
        animation.autoreverses = true
        
        animation.fromValue = NSValue(cgPoint: CGPoint(x: elementToBeShake.center.x - 2, y: elementToBeShake.center.y - 0.5))
        animation.toValue = NSValue(cgPoint: CGPoint(x: elementToBeShake.center.x + 2, y: elementToBeShake.center.y + 0.5))
        DispatchQueue.main.async {
            elementToBeShake.layer.add(animation, forKey: "position")
        }
    }
    
    static func applySmoothAnimation(_ elementToBeSmooth: UIView) {
        let animations   : [StockAnimation] = [.slide(.left, .severely), .fadeIn]
        let animation    = SpringAnimation(duration: 0.8)
        let sortFunction = LinearSortFunction(direction: .topToBottom, interObjectDelay: 0.1)

        DispatchQueue.main.async {
            elementToBeSmooth.isHidden = false
            elementToBeSmooth.spruce.animate(animations, animationType: animation, sortFunction: sortFunction)
        }
    }
}
