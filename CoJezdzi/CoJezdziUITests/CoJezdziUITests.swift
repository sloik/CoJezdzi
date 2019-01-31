import XCTest
import SBTUITestTunnel

class CoJezdziUITests: XCTestCase {
    
    var application: Void
    

    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launchTunnel()
        app.performCustomCommandNamed("setMock", object: nil)
        
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testExample() {
        

//            let objReturnedByBlock = app.performCustomCommandNamed("dupak", object: "setCurrent")
//        dupak = app.performCustomCommandNamed("print", object: nil)
        
//            app.wait(for: .unknown, timeout: 20)
        
        
        //        App.stubGetTrams(to: [WarsawVehicleDto])
        //        // Current.dataPrivider.getTrams(completion: @escaping ResultBlock)
        //        // do "completion" wchodzi przekazyna arejka "to" [WarsawVehicleDto]
        //
        //
    }
}

extension XCTestCase {
    func wait(forElement element: XCUIElement, timeout: TimeInterval) {
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: element)
        waitForExpectations(timeout: timeout)
    }
}
