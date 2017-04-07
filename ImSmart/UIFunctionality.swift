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
    static func applyShadow(toView: AnyObject, withColor: UIColor) {
        toView.layer.shadowColor = withColor.cgColor
        toView.layer.shadowOffset = CGSize.zero
        toView.layer.shadowOpacity = 0.7
        toView.layer.shadowRadius = 10
    }
    
    static func applyShakyAnimation(elementToBeShake: AnyObject, duration: Float, repeatCount: Float = .infinity) {
        DispatchQueue.main.async {
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = CFTimeInterval(duration)
            animation.repeatCount = repeatCount
            animation.autoreverses = true
            
            animation.fromValue = NSValue(cgPoint: CGPoint(x: elementToBeShake.center.x - 5, y: elementToBeShake.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: elementToBeShake.center.x + 5, y: elementToBeShake.center.y))
            elementToBeShake.layer.add(animation, forKey: "position")
        }
    }
    
    static func applySmoothAnimation(elementToBeSmooth: UIView) {
        let animations   : [StockAnimation] = [.slide(.left, .severely), .fadeIn]
        let animation    = SpringAnimation(duration: 0.8)
        let sortFunction = LinearSortFunction(direction: .topToBottom, interObjectDelay: 0.1)

        DispatchQueue.main.async {
            elementToBeSmooth.isHidden = false
            elementToBeSmooth.spruce.animate(animations, animationType: animation, sortFunction: sortFunction)
        }
    }
}
