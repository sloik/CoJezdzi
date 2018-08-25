import UIKit

import ReSwift
import PlaygroundSupport
import Overture

@testable import AppFramework

var str = "Hello, playground"

let window = UIWindow()
App.takeOff(window: window)

let (parent, _) = playgroundControllers(device: .phone5_5inch,
                                        orientation: .portrait,
                                        child: window.rootViewController!)

PlaygroundPage.current.liveView = parent
