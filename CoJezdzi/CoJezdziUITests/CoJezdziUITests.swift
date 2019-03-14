import XCTest
import SBTUITestTunnel
import Overture


//@testable import AppFramework

class CoJezdziUITests: XCTestCase {


    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launchTunnel()
        app.performCustomCommandNamed("setMocks", object: {
            arg in


            let about   = \Environment.constants.ui.settings.menuLabels.aboutApp
            let marks   = \Environment.constants.ui.settings.menuLabels.tramMarks
            let aOnly   = \Environment.constants.ui.settings.menuLabels.bussesOnly
            let tOnly   = \Environment.constants.ui.settings.menuLabels.tramsOnly
            let filters = \Environment.constants.ui.settings.menuLabels.filters

            // new instance modified based on .mock template
            Current = with(.mock, concat(
                set(about, "ciastko"),
                set(marks, "pizza"),
                set(aOnly, "AWTOBUS"),
                set(tOnly, "TRAMŁAJNO"),
                set(filters, "FILTRYS")))


            return arg
        })

    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testExample() {




        let settingsButton = app.buttons["settings"]
        settingsButton.tap()



//        let env = Environment.mock
//        with

//            let objReturnedByBlock = app.performCustomCommandNamed("dupak", object: "setCurrent")
//        dupak = app.performCustomCommandNamed("print", object: nil)
        
//            app.wait(for: .unknown, timeout: 20)
        
        
        //        App.stubGetTrams(to: [WarsawVehicleDto])
        //        // Current.dataPrivider.getTrams(completion: @escaping ResultBlock)
        //        // do "completion" wchodzi przekazyna arejka "to" [WarsawVehicleDto]
        //
        //
    }
}

extension XCTestCase {
    func wait(forElement element: XCUIElement, timeout: TimeInterval) {
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: element)
        waitForExpectations(timeout: timeout)
    }
}
