//  Copyright (c) 2016, Janusz Chudzynski - Felipe Neves Brito
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice,
//  this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  * Neither the name of  nor the names of its contributors may be used to
//  endorse or promote products derived from this software without specific
//  prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

//
//  DataStructures.swift
//  iBeaconManager
//
//  Created by Janusz Chudzynski on 6/21/16.


import Foundation
import CoreLocation

public extension CLProximity {
    var sortIndex : Int {
        switch self {
        case .immediate:
            return 0
        case .near:
            return 1
        case .far:
            return 2
        case .unknown:
            return 3
        }
    }
}

/**iBeacon*/
open class iBeacon : NSObject {
    
    /// iBeacon Minor
    open let minor:UInt16?
    
    /// iBeacon Major
    open let major:UInt16?
    
    /// Internal name - it will be used by firebase
    fileprivate(set) open var id:String
    
    /// Human readable id
    fileprivate(set) open var readeableId:String = ""
    
    /// iBeacon UUID
    open let UUID: String
    
    
    /// Default proximity
    open var proximity: CLProximity  = CLProximity.unknown
    
    
    /// Default state
    open var state:CLRegionState = CLRegionState.unknown
    
    
    
    public init(beacon:CLBeacon) {
        self.UUID = beacon.proximityUUID.uuidString
        self.minor = beacon.minor.uint16Value
        self.major = beacon.major.uint16Value
        self.id = ""
        self.proximity = beacon.proximity
        super.init()
        self.id = generateId()
    }
    
    /**Initializer*/
    public init(minor:UInt16?, major:UInt16?, proximityId:String){
        
        self.UUID = proximityId
        self.major = major
        self.minor = minor
        self.id = "" // silence the warning
        
        super.init()
        self.id = generateId()
    }
    
    
    /**Initializer*/
    public init(minor:UInt16?, major:UInt16?, proximityId:String, id:String){
        
        self.UUID = proximityId
        self.major = major
        self.minor = minor
        self.id = id
        super.init()
    }
    
    /**
     
     Generate a unique id based on the iBecon's paramaters
     
     - Returns: A Unique ID
     */
    func generateId() -> String {
        return "\(self.UUID)m\(String(describing: self.major))m\(String(describing: self.minor))"
    }
    
    override open var description:String {
        return debugDescription
    }
    
    override open var debugDescription:String{
        
        return "\(self.UUID)--\(String(describing: self.major))--\(String(describing: self.minor))"
    }
    
    override open func isEqual(_ object: Any?) -> Bool {
        
        if let minor = self.minor{
            let minorBool = (minor  == (object as! iBeacon).minor)
            if !minorBool {
                return false
            }
        }
        if let major = self.major{
            let minorBool = (major  == (object as! iBeacon).major)
            if !minorBool {
                return false
            }
        }
        
        
        if self.UUID.lowercased() == (object as AnyObject).UUID.lowercased(){
            return true
        }
        return false
    }
}
