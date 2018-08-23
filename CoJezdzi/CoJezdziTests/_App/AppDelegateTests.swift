
import XCTest
import Overture

@testable import CoJezdzi

class AppDelegateTests: XCTestCase {

    var systemUnderTest: AppDelegate!
    
    override func setUp()    { systemUnderTest = AppDelegate() }
    override func tearDown() { systemUnderTest = nil           }

    func test_whenApplicationFinishLaunching_then_itLoadsStuffFromPersistance() {
        // arrange
        var didLoad = false
        
        Current = with(
            .mock,
            set(\.persistance.load,
                { didLoad = true }
        ))
        
        // act
        _ = systemUnderTest.application(.shared, didFinishLaunchingWithOptions: nil)
        
        // assert
        XCTAssert(didLoad, "Did not used persistance!")
    }
}
