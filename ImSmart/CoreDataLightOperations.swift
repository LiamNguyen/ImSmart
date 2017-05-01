//
//  CoreDataLightOperations.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /30/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataLightOperations {
    static let sharedInstance = CoreDataLightOperations()
    
    private let appDelegate : AppDelegate!
    private var context     : NSManagedObjectContext?
    
    private init() {
        self.appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.context        = appDelegate.persistentContainer.viewContext
    }
    
    func storeLights(lights: [LightCellViewModel]) {
        clearLights()
        context?.perform({ 
            let _ = lights.map { currentLight in
                let rollbackLight           = Light(context: self.context!)
                
                rollbackLight.area          = currentLight.area.value
                rollbackLight.brightness    = Int16(currentLight.brightness.value)
                rollbackLight.isOn          = currentLight.isOn.value
            }
            self.appDelegate.saveContext()
        })
    }
    
    private func clearLights() {
        context?.perform({
            let _ = self.getLights().map { [unowned self] light in
                if let light = light as? Light {
                    self.context?.delete(light)
                    self.appDelegate.saveContext()
                }
            }
        })
    }
    
    func getLights() -> NSArray {
        do {
            return try context!.fetch(Light.fetchRequest()) as NSArray
        } catch let error {
            print("ERROR: Cannot fetch lights from CoreData\n\(error)")
            return NSArray()
        }
    }
    
    private func isLightsStored() -> Bool {
        do {
            return try context?.count(for: Light.fetchRequest()) == 0 ? false : true
        } catch let error {
            print("ERROR: Cannot count lights from CoreData\n\(error)")
            return false
        }
    }
}
