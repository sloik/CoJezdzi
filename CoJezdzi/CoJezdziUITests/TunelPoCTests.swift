import XCTest
import SBTUITestTunnel
import Overture
import SnapshotTesting

@testable import AppFramework

class TunelPoCTests: XCTestCase {
    
    var application: Void
    

    
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

            _ = app
                .performCustomCommandNamed("dupak",
                                           object: labelsData)


        let box = app.staticTexts["LineId"].firstMatch
        wait(forElement: box,timeout: 200)

        assertSnapshot(
            matching: app.windows.firstMatch.screenshot().image.removingStatusBar!,
            as: .image
        )
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
                                                              object: nil)
            debugPrint(currrentScene)


        } while true
    }
}

extension UIImage {

    var removingStatusBar: UIImage? {
        guard let cgImage = cgImage else {
            return nil
        }

        let statusBarHeight = XCUIApplication()
            .statusBars
            .firstMatch
            .screenshot()
            .image
            .size
            .height

        let yOffset = statusBarHeight * scale
        let rect = CGRect(
            x: 0,
            y: Int(yOffset),
            width: cgImage.width,
            height: cgImage.height - Int(yOffset)
        )

        if let croppedCGImage = cgImage.cropping(to: rect) {
            return UIImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
        }

        return nil
    }
}

