
import XCTest

@testable import CoJezdzi

class CustomCodableTests: XCTestCase {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
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
        
        
        let initial = SettingsState.Filter.tram(on: true)
        
        let result = encodeDecode(initial)
        
        XCTAssert(initial == result, "")
    }
    
}

extension CustomCodableTests {
    func encodeDecode<TestedType: Codable>(_ object: TestedType) -> TestedType {
        return try! decoder.decode(TestedType.self, from: try! encoder.encode(object))
    }
}
