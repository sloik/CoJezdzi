
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
        
        let request2 = SBTRequestMatch(url: "https://api.um.warszawa.pl/api/action/busestrams_get?resource_id=c7238cfe-8b1f-4c38-bb4a-de386db7e776&a    pikey=cffa0471-5750-4e90-861b-fd499ad30ec6&type=2")
        let request = SBTRequestMatch(url: "https://api.um.warszawa.pl/api/action/busestrams_get")
        let response = SBTStubResponse(fileNamed: "line213.json")
        let stub = app.stubRequests(matching: request2, response: response)
        let line = app.otherElements["DUPAKI"]
        
        
        XCTAssert(line.exists == true)
        
    }
    
}
