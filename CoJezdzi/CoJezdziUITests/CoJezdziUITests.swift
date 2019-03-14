import XCTest
import SBTUITestTunnel
import Overture


@testable import AppFramework

class CoJezdziUITests: XCTestCase {


    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launchTunnel()
    }
    
    override func tearDown() {
        
        super.tearDown()
    }

    func testExample1() {
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
            .performCustomCommandNamed("setMocks",
                                       object: labelsData)

        let box = app.staticTexts["LineId"].firstMatch
        wait(forElement: box,timeout: 20)

        XCTAssertEqual(box.label, "Wybierz Linie")

        debugPrint("ddasda")

    }


    func testExample3(){

        let actions = 


        let returnedObj = app.performCustomCommandNamed("getRandomRoute", object: actions)

    }
}
extension XCTestCase {
    func wait(forElement element: XCUIElement, timeout: TimeInterval) {
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: element)
        waitForExpectations(timeout: timeout)
    }
}
