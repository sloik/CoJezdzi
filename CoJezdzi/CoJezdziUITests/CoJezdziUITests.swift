
import XCTest
import SBTUITestTunnel

class CoJezdziUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        

        continueAfterFailure = false
        
        app.launchTunnel()

    }
    
    override func tearDown() {
     
        super.tearDown()
    }
    
    func testExample() {
        
        let request2 = SBTRequestMatch(url: "https://api.um.warszawa.pl/api/action/busestrams_get?resource_id=c7238cfe-8b1f-4c38-bb4a-de386db7e776&apikey=cffa0471-5750-4e90-861b-fd499ad30ec6")
        
        let response = SBTStubResponse(fileNamed:"line213.json", responseTime: 10)
        
        let stub = app.stubRequests(matching: request2, response: response)
        
        let line = app.otherElements["DUPAKI"]
        wait(forElement: line, timeout: 10)
        
        let lines = app.descendants(matching: .other).matching(identifier: "DUPAKI").allElementsBoundByIndex
       
        XCTAssert(line.exists == true, "DUPA DUPA")
        XCTAssert(lines.count == 1, "ZLE ZLE")
    }
}


extension XCTestCase {
    func wait(forElement element: XCUIElement, timeout: TimeInterval) {
        let predicate = NSPredicate(format: "exists == 1")
        
        expectation(for: predicate, evaluatedWith: element)
        waitForExpectations(timeout: timeout)
    }
}
