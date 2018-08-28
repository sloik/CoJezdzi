//

import XCTest
@testable import TestsHelpper
@testable import AppFramework
import ReSwift
import Overture


class CoJezdziUITests: XCTestCase {
    

        
    override func setUp() {
        super.setUp()
        
        Current = .mock
       
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
        
       
        
        
    }
    
}
