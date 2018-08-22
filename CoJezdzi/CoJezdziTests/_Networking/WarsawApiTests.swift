@testable import CoJezdzi

import XCTest
import Foundation

class WarsawApiTests: XCTestCase {
    
    // hooking up Env...
    func test_failingTest() {
        // arrange
        Current = .errorMock

        // act
        Current
            .dataProvider
            .getTrams { (result) in
                // assert
                switch result {
                    
                case .succes(_): XCTFail("Should get an error" )
                case .error(_) : XCTAssert(true)
                }
        }        
    }
}

