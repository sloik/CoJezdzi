import XCTest
import SBTUITestTunnel
import Overture

@testable import AppFramework

class CoJezdziUITests: XCTestCase {
    
}

extension XCTestCase {
    func wait(forElement element: XCUIElement, timeout: TimeInterval) {
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: element)
        waitForExpectations(timeout: timeout)
    }
}
