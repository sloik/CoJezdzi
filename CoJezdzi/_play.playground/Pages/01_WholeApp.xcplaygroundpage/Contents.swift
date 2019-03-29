//:[ToC](ToC) | [Previous](@previous) | [Next](@next)

import UIKit
import PlaygroundSupport

@testable import AppFramework

let window = UIWindow()
App.takeOff(window: window)

let (parent, _) = playgroundControllers(device: .phone5_5inch,
                                        orientation: .portrait,
                                        child: window.rootViewController!)
PlaygroundPage.current.liveView = parent

type(of: \RoutingState.destination)

//:[ToC](ToC) | [Previous](@previous) | [Next](@next)
