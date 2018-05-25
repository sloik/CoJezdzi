
import XCTest

@testable import CoJezdzi

class CustomCodableTests: XCTestCase {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    func test_SettingsState_FilterExample() {
        let values =
        [SettingsState.Filter.tram(on: false),             SettingsState.Filter.tram(on: true),
         SettingsState.Filter.bus(on: false),              SettingsState.Filter.bus(on: true),
         SettingsState.Filter.previousLocation(on: false), SettingsState.Filter.previousLocation(on: true)]
        
        values.forEach {
            XCTAssert($0 == self.encodeDecode($0), "\($0) != \(self.encodeDecode($0))")
        }
    }
    
}

extension CustomCodableTests {
    func encodeDecode<TestedType: Codable>(_ object: TestedType) -> TestedType {
        return try! decoder.decode(TestedType.self, from: try! encoder.encode(object))
    }
}
