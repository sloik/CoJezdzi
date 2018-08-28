//
//  CoJezdziUITests.swift
//  CoJezdziUITests
//
//  Created by Lukasz Stocki on 18/02/16.
//  Copyright © 2016 A.C.M.E. All rights reserved.
//

import XCTest
import TestsHelpper
import AppFramework
import ReSwift
import Overture


class CoJezdziUITests: XCTestCase {
    

        
    override func setUp() {
        super.setUp()
        
       
        continueAfterFailure = false
        XCUIApplication().launch()
        

        
      
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let button = XCUIApplication().buttons["UserSettings"]
        let done = XCUIApplication().navigationBars["Ustawienia"].buttons["Done"]
        
        button.waitForExistence(timeout: 10)
        button.tap()
        
        done.tap()
        
        XCUIApplication().alerts["Allow “Co Jeździ” to access your location while you are using the app?"].buttons["Allow"].tap()
        
        let app = XCUIApplication()
        app.links["Legal"].tap()
        app.children(matching: .window).element(boundBy: 6).children(matching: .other).element.tap()

        
        
    }
    
}
