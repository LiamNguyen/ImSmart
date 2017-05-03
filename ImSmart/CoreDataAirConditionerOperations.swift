//
//  CoreDataAirConditionerOperations.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /02/05/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataAirConditionerOperations {
    static let sharedInstance = CoreDataAirConditionerOperations()
    
    private let appDelegate : AppDelegate!
    private var context     : NSManagedObjectContext?
    
    private init() {
        self.appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.context        = appDelegate.persistentContainer.viewContext
    }
    
    func storeAirConditioners(airConditioners: [AirConditionerViewModel]) {
        clearAirConditioners()
        let _ = airConditioners.map { currentAirCon in
            let rollBackAirCon          = AirConditioner(context: self.context!)
            //STORE TO CORE DATA
            self.appDelegate.saveContext()
        }
        self.printAirConditionersFromCoreData()
    }
    
    private func clearAirConditioners() {
        let airConditioners = NSFetchRequest<NSFetchRequestResult>(entityName: "AirConditioner")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: airConditioners)
        
        do {
            try self.context?.persistentStoreCoordinator?.execute(deleteRequest, with: self.context!)
        } catch let error {
            print("ERROR: Cannot delete air conditioners from Coredata\n\(error)")
        }
    }
    
    func getAirConditioners() -> NSArray {
        do {
            return try context!.fetch(AirConditioner.fetchRequest()) as NSArray
        } catch let error {
            print("ERROR: Cannot fetch air conditioners from CoreData\n\(error)")
            return NSArray()
        }
    }
    
    private func isAirConditionersStored() -> Bool {
        do {
            return try context?.count(for: AirConditioner.fetchRequest()) == 0 ? false : true
        } catch let error {
            print("ERROR: Cannot count air conditioners from CoreData\n\(error)")
            return false
        }
    }
    
    func printAirConditionersFromCoreData() {
        print("START________________")
        let _ = getAirConditioners().map { airCon in
            if let airCon = airCon as? AirConditioner {
                print("Id           : \(airCon.id)")
                print("Is on        : \(airCon.isOn)")
                print("Fan speed    : \(airCon.fanSpeed!)")
                print("Swing        : \(airCon.swing!)")
                print("Mode         : \(airCon.mode!)")
                print("Temperature  : \(airCon.temperature)")
                print("Is timer on  : \(airCon.isTimerOn)")
                print("Off time     : \(airCon.offTime!)")
                print("Area         : \(airCon.area!)")
            }
        }
        print("END________________")
    }
}
