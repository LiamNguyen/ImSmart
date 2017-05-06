//
//  UIApplicationExtension.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /30/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    class func topViewController(_ controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(presented)
        }
        return controller
    }
}
