@testable import AppFramework

import XCTest

class SettingsStateTests: XCTestCase {
    
    func test<T: Codable & Equatable>(_ f: T, file: StaticString = #file, line: UInt = #line) {
        do {
            let r = try encodeDecode(f)
            XCTAssert(f == r, "\(f) != \(r)", file: file, line: line)
        } catch {
            XCTFail("Could not encode/decode: \(f)", file: file, line: line)
        }
    }
    
    func test_SettingsState_Filter() {
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
