import XCTest
import SBTUITestTunnel
import Overture

@testable import AppFramework

class CoJezdziUITests: XCTestCase {
    
    var application: Void
    

    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launchTunnel()
        app.performCustomCommandNamed("setMocks", object: nil)
        
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testExample() {
        let labels: Constants.UI.Settings.MenuLabels = with(
            Constants.UI.Settings.MenuLabels(),
            concat(
                set(\Constants.UI.Settings.MenuLabels.aboutApp, "about about"),
                set(\Constants.UI.Settings.MenuLabels.tramMarks, "marks marks"),
                set(\Constants.UI.Settings.MenuLabels.bussesOnly, "AAA"),
                set(\Constants.UI.Settings.MenuLabels.tramsOnly, "TTTT"),
                set(\Constants.UI.Settings.MenuLabels.filters, "FFFF"))
        )

        let labelsData = try! JSONEncoder().encode(labels)

            let objReturnedByBlock = app
                .performCustomCommandNamed("dupak",
                                           object: labelsData)


        let box = app.staticTexts["LineId"].firstMatch
        wait(forElement: box,timeout: 20)

        XCTAssertEqual(box.label, "FFFF")

        debugPrint("ddasda")

    }
}

extension XCTestCase {
    func wait(forElement element: XCUIElement, timeout: TimeInterval) {
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: element)
        waitForExpectations(timeout: timeout)
    }
}
