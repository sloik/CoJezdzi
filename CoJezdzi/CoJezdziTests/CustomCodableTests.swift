
import XCTest

@testable import CoJezdzi

class CustomCodableTests: XCTestCase {
    
    func test_SettingsState_Filter() {
        func test(_ f: SettingsState.Filter , file: StaticString = #file, line: UInt = #line) {
            do {
                let result = try encodeDecode(f)
                XCTAssert(f == result, "\(f) != \(result)", file: file, line: line)
            } catch {
                XCTFail("Could not encode/decode: \(f)", file: file, line: line)
            }
        }
        
        Runner.run(tests:
            test(SettingsState.Filter.tram(on: false)),
            test(SettingsState.Filter.tram(on: true)),
            test(SettingsState.Filter.bus(on: false)),
            test(SettingsState.Filter.bus(on: true)),
            test(SettingsState.Filter.previousLocation(on: false)),
            test(SettingsState.Filter.previousLocation(on: true))
        )
    }
}
