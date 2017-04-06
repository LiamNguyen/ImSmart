//
//  LightTests.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /04/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import XCTest
@testable import ImSmart

class LightViewModelTests: XCTestCase {
    
    var kitchenLight: Light!
    var kitchenLightViewModel: LightViewModel!
    
    override func setUp() {
        super.setUp()
        
        kitchenLight = Light(brightness: 0, area: "Kitchen")
        kitchenLightViewModel = LightViewModel(light: kitchenLight)
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
    
    func testLightModelUpdate() {
        kitchenLightViewModel.isOn.value = true
        kitchenLightViewModel.brightness.value = 50
        kitchenLightViewModel.area.value = "Living room"
        
        XCTAssertEqual(kitchenLight.isOn, true)
        XCTAssertEqual(kitchenLight.brightness, 50)
        XCTAssertEqual(kitchenLight.area, "Living room")
        
        kitchenLightViewModel.isOn.value = false
        kitchenLightViewModel.brightness.value = 100
        
        XCTAssertEqual(kitchenLight.brightness, 50)
    }
}
