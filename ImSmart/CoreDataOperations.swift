//
//  CoreDataOperations.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /30/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@available(iOS 10.0, *)
class CoreDataOperations {
    static let sharedInstance = CoreDataOperations()
    
    private let appDelegate : AppDelegate!
    private var context     : NSManagedObjectContext!
    
    private init() {
        self.appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.context        = appDelegate.persistentContainer.viewContext
    }
    
    func storeLights(lights: [LightCellViewModel]) {
        clearLights()
        let _ = lights.map { currentLight in
            let rollbackLight           = CoreDataLight(context: self.context)
            
            rollbackLight.area          = currentLight.area.value
            rollbackLight.brightness    = Int16(currentLight.brightness.value)
            rollbackLight.isOn          = currentLight.isOn.value
        }
        appDelegate.saveContext()
    }
    
    private func clearLights() {
        let _ = getLights().map { [unowned self] light in
            if let light = light as? CoreDataLight {
                self.context.delete(light)
                self.appDelegate.saveContext()
            }
        }
    }
    
    func getLights() -> NSArray {
        do {
            return try context.fetch(CoreDataLight.fetchRequest()) as NSArray
        } catch {
            print("ERROR: Cannot fetch lights from CoreData")
            return NSArray()
        }
    }
    
    private func isLightsStored() -> Bool {
        do {
            return try context.count(for: CoreDataLight.fetchRequest()) == 0 ? false : true
        } catch  {
            print("ERROR: Cannot count lights from CoreData")
            return false
        }
    }
}
