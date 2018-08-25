@testable import AppFramework

import XCTest
import Foundation

class WarsawApiTests: XCTestCase {
    
    func test_passingSuccesToCompletion() {
        // arrange
        Current = .mock

        // act
        Current
            .dataProvider
            .getTrams { (result) in
                // assert
                switch result {
                case .succes(_): XCTAssert(true)
                case .error(_) : XCTFail("Should get succes")
                }
        }        
    }
    
    func test_passingErrorToCompletion() {
        // arrange
        Current = .errorMock
        
        // act
        Current
            .dataProvider
            .getTrams { (result) in
                // assert
                switch result {
                case .succes(_): XCTFail("Should get error")
                case .error(_) : XCTAssert(true)
                }
        }
    }
}

