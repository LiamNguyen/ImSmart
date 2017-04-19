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
    
    var lightViewModel: LightViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.lightViewModel = LightViewModel()
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
        let invalidJsonObject       = [self.lightViewModel]
        let invalidConvertedString  = Helper.jsonStringify(jsonObject: invalidJsonObject as AnyObject)
        
        XCTAssertEqual(invalidConvertedString, String())
        
        let validJsonObject: [String: Any]  = [
                                                "name"  : "testname",
                                                "age"   : 18
                                            ]
        let validConvertedString     = Helper.jsonStringify(jsonObject: validJsonObject as AnyObject)
        let expectedConversionResult = "{\"age\":18,\"name\":\"testname\"}"
    
        XCTAssertEqual(validConvertedString, expectedConversionResult)
    }
    
    func testBuildJSONObject() {
        let mockupLightsReduce = reduceMockupLights()
        
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
    
    func testParseJSONToLightCellViewModel() {
        let mockupLightsReduce      = reduceMockupLights()
        let jsonObject              = Helper.buildJSONObject(fromLightCellViewModel: mockupLightsReduce)
        let jsonString              = Helper.jsonStringify(jsonObject: jsonObject as AnyObject)
        let data                    = jsonString.data(using: .utf8)!
        
        let convertedMockupLights   = Helper.parseJSONToLightCellViewModel(
            data: data,
            lightViewModel: self.lightViewModel
        )
        
        let firstLightViewModel     = convertedMockupLights[0]
        let secondLightViewModel    = convertedMockupLights[1]
        let thirdLightViewModel     = convertedMockupLights[2]
        
        XCTAssertEqual(firstLightViewModel.isOn.value, false)
        XCTAssertEqual(firstLightViewModel.brightness.value, 0)
        XCTAssertEqual(firstLightViewModel.area.value, "Kitchen")
        
        XCTAssertEqual(secondLightViewModel.isOn.value, false)
        XCTAssertEqual(secondLightViewModel.brightness.value, 0)
        XCTAssertEqual(secondLightViewModel.area.value, "Livingroom")
        
        XCTAssertEqual(thirdLightViewModel.isOn.value, false)
        XCTAssertEqual(thirdLightViewModel.brightness.value, 70)
        XCTAssertEqual(thirdLightViewModel.area.value, "Front yard")
    }
    
    func reduceMockupLights() -> [LightCellViewModel] {
        var mockupLightsReduce = [LightCellViewModel]()
        
        for i in 0...self.lightViewModel.mockupLights.value.count {
            if i > 3 {
                break
            }
            print(self.lightViewModel.mockupLights.value[i].area.value)
            mockupLightsReduce.append(self.lightViewModel.mockupLights.value[i])
        }
        
        return mockupLightsReduce
    }

}
