//
//  LightCellViewModelTests.swift
//  ImSmart
//
//  Created by Cao Do Nguyen on /04/04/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import XCTest
@testable import ImSmart

class LightCellViewModelTests: XCTestCase {
    
    var lightViewModel: LightViewModel!
    var kitchenLight: Light!
    var kitchenLightCellViewModel: LightCellViewModel!
    
    override func setUp() {
        super.setUp()
        
        lightViewModel = LightViewModel()
        kitchenLight = Light(brightness: 0, area: "Kitchen")
        kitchenLightCellViewModel = LightCellViewModel(light: kitchenLight, parentViewModel: lightViewModel)
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
        kitchenLightCellViewModel.isOn.value = true
        kitchenLightCellViewModel.brightness.value = 50
        kitchenLightCellViewModel.area.value = "Living room"
        
        XCTAssertEqual(kitchenLight.isOn, true)
        XCTAssertEqual(kitchenLight.brightness, 50)
        XCTAssertEqual(kitchenLight.area, "Living room")
        
        kitchenLightCellViewModel.isOn.value = false
        kitchenLightCellViewModel.brightness.value = 100
        
        XCTAssertEqual(kitchenLight.brightness, 50)
    }
}
