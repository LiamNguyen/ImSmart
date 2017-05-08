//
//  AirConditionerProperties.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /02/05/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import CoreData


extension AirConditioner {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<AirConditioner>(entityName: "AirConditioner") as! NSFetchRequest<NSFetchRequestResult>
    }

    @NSManaged public var id            : Int16
    @NSManaged public var isOn          : Bool
    @NSManaged public var fanSpeed      : String?
    @NSManaged public var swing         : String?
    @NSManaged public var mode          : String?
    @NSManaged public var temperature   : Double
    @NSManaged public var isTimerOn     : Bool
    @NSManaged public var offTime       : String?
    @NSManaged public var area          : String?

}
