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
        app.performCustomCommandNamed("setMock", object: nil)
        
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testExample() {

        let about   = \Environment.constants.ui.settings.menuLabels.aboutApp
        let marks   = \Environment.constants.ui.settings.menuLabels.tramMarks
        let aOnly   = \Environment.constants.ui.settings.menuLabels.bussesOnly
        let tOnly   = \Environment.constants.ui.settings.menuLabels.tramsOnly
        let filters = \Environment.constants.ui.settings.menuLabels.filters

        // new instance modified based on .mock template
        Current = with(.mock, concat(
            set(about, "about"),
            set(marks, "marks"),
            set(aOnly, "A"),
            set(tOnly, "T"),
            set(filters, "F")))

        let env: Constants.UI.Settings.MenuLabels = with(
            Constants.UI.Settings.MenuLabels(),
            concat(
                set(\Constants.UI.Settings.MenuLabels.aboutApp, "about about"),
                set(\Constants.UI.Settings.MenuLabels.tramMarks, "marks marks"),
                set(\Constants.UI.Settings.MenuLabels.bussesOnly, "AAA"),
                set(\Constants.UI.Settings.MenuLabels.tramsOnly, "TTTT"),
                set(\Constants.UI.Settings.MenuLabels.filters, "FFFF"))
        )

            let objReturnedByBlock = app
                .performCustomCommandNamed("dupak",
                                           object: env)


//        wait(forElement: <#T##XCUIElement#>,
//             timeout: <#T##TimeInterval#>)

    }
}

extension XCTestCase {
    func wait(forElement element: XCUIElement, timeout: TimeInterval) {
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: element)
        waitForExpectations(timeout: timeout)
    }
}
