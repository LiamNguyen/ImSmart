//
//  LightProperties.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /01/05/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import CoreData

extension Light {
    
    @nonobjc public override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<Light>(entityName: "Light") as! NSFetchRequest<NSFetchRequestResult>
    }
    
    @NSManaged public var area          : String?
    @NSManaged public var brightness    : Int16
    @NSManaged public var isOn          : Bool
    @NSManaged public var id            : Int16
    
}
