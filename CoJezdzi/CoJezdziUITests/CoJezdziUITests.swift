import XCTest
import SBTUITestTunnel
import Overture
import SnapshotTesting

@testable import AppFramework

class CoJezdziUITests: XCTestCase {


    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.performCustomCommandNamed("setMocks", object: nil)
        app.launchTunnel(withOptions: ["mocks"],
                         startupBlock: nil)
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

    func test_inifinity() {
        let gotoSceneCommand = "gotoSceneCommand"
        let getCurrentScene = "getCurrentScene"


        repeat {
            // wiem dokad
            let randomDestination = RoutingDestination.allCases.randomElement()!


            // ustawic stan dla destynacji



            // id tam!
            _ = app.performCustomCommandNamed(gotoSceneCommand,
                                              object:  randomDestination.rawValue)

            sleep(5)

            // funcRandomActionForDestiantion(randomDestination)
            let currrentScene = app.performCustomCommandNamed(getCurrentScene,
                                                              object: nil) as! String

            let crd = RoutingDestination(rawValue: currrentScene)!

            switch crd {
            case .map:
                assertSnapshot(matching: app.windows.firstMatch.screenshot().image.removingStatusBarAndTimerIndycator!, as: .image(precision: 0.975), named: "map")
            case .settings:
                assertSnapshot(matching: app.windows.firstMatch.screenshot().image.removingStatusBar!, as: .image, named: "settings")
            case .linesFilter:
               assertSnapshot(matching: app.windows.firstMatch.screenshot().image.removingStatusBar!, as: .image, named: "linesFilter")
            case .aboutApp:
                sleep(5)
                assertSnapshot(matching: app.windows.firstMatch.screenshot().image.removingStatusBar!, as: .image(precision: 0.9), named: "aboutApp")
            }


        } while true
    }
}
extension XCTestCase {
    func wait(forElement element: XCUIElement, timeout: TimeInterval) {
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: element)
        waitForExpectations(timeout: timeout)
    }
}
