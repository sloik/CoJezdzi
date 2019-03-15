import XCTest
import SBTUITestTunnel
import Overture
import SnapshotTesting

@testable import AppFramework


enum TunelCommand: String {
    case gotoScene = "gotoSceneCommand"
    case getCurrentScene = "getCurrentScene"
}


class CoJezdziUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.performCustomCommandNamed("setMocks", object: nil)
        app.launchTunnel(withOptions: ["mocks"],
                         startupBlock: nil)
    }
    


    func test_inifinity() {
        var count = 0
        repeat {
            count += 1


            randomDestination
                .map(navigateTo)
                .flatMap { sleep(5) }
                .flatMap {_ in currentScene }
                .map{ snapshot($0) }



            debugPrint("😎 \(count)")
        } while true
    }
}


extension CoJezdziUITests {
    var currentScene: RoutingDestination? {
        let sceneId = app.perform(.getCurrentScene, nil) as! String
        return RoutingDestination(rawValue: sceneId)
    }


    var randomDestination: RoutingDestination? {
        return RoutingDestination.allCases.randomElement()
    }

    func navigateTo( _ destination: RoutingDestination) {
        _ = app
            .perform(.gotoScene,
                     destination.rawValue)
    }

    func snapshot(_ destination: RoutingDestination,
                  _ testName: String = #function) {
        switch destination {
        case .map:
            assertSnapshot(matching: app.windows.firstMatch.screenshot().image.removingStatusBarAndTimerIndycator!, as: .image(precision: 0.975), named: testName + "-map")
        case .settings:
            assertSnapshot(matching: app.windows.firstMatch.screenshot().image.removingStatusBar!, as: .image, named: testName + "-settings")
        case .linesFilter:
            assertSnapshot(matching: app.windows.firstMatch.screenshot().image.removingStatusBar!, as: .image, named: testName + "-linesFilter")
        case .aboutApp:
            sleep(5)
            assertSnapshot(matching: app.windows.firstMatch.screenshot().image.removingStatusBar!, as: .image(precision: 0.9),
                           named: testName + "-aboutApp")
        }
    }
}

extension XCTestCase {
    func wait(forElement element: XCUIElement, timeout: TimeInterval) {
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: element)
        waitForExpectations(timeout: timeout)
    }
}

extension SBTUITunneledApplication {
    func perform(_ command: TunelCommand,
                 _ object: Any?) -> Any? {
        return performCustomCommandNamed(command.rawValue,
                                         object: object)
    }
}
