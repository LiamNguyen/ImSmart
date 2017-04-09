//
//  HelperTests.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /10/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import XCTest
@testable import ImSmart

class HelperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testJsonStringify() {
        let lightViewModel          = LightViewModel()
        let invalidJsonObject       = [lightViewModel]
        let invalidConvertedString  = Helper.jsonStringify(jsonObject: invalidJsonObject as AnyObject)
        
        XCTAssertEqual(invalidConvertedString, String())
        
        let validJsonObject: [String: Any]  = [
                                                "name"  : "testname",
                                                "age"   : 18
                                            ]
        let validConvertedString     = Helper.jsonStringify(jsonObject: validJsonObject as AnyObject)
        let expectedConversionResult = "{\"name\":\"testname\",\"age\":18}"
    
        XCTAssertEqual(validConvertedString, expectedConversionResult)
    }
    
    func testBuildJSONObject() {
        let lightViewModel      = LightViewModel()
        var mockupLightsReduce  = [LightCellViewModel]()
        
        for i in 0...lightViewModel.mockupLights.value.count {
            if i > 3 {
                break
            }
            mockupLightsReduce.append(lightViewModel.mockupLights.value[i])
        }
        
        let jsonObject: [[String: Any]] = Helper.buildJSONObject(fromLightCellViewModel: mockupLightsReduce)
        let firstItem   = jsonObject[0]
        let secondItem  = jsonObject[1]
        let thirdItem   = jsonObject[2]
        
        XCTAssertEqual(firstItem["isOn"] as! Bool, false)
        XCTAssertEqual(firstItem["brightness"] as! Int, 0)
        XCTAssertEqual(firstItem["area"] as! String, "Kitchen")
        
        XCTAssertEqual(secondItem["isOn"]  as! Bool, false)
        XCTAssertEqual(secondItem["brightness"] as! Int, 0)
        XCTAssertEqual(secondItem["area"] as! String, "Livingroom")
        
        XCTAssertEqual(thirdItem["isOn"] as! Bool, false)
        XCTAssertEqual(thirdItem["brightness"] as! Int, 70)
        XCTAssertEqual(thirdItem["area"] as! String, "Front yard")
    }

}
