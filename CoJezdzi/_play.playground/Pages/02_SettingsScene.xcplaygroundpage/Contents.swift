//: [Previous](@previous)
import UIKit
import PlaygroundSupport

@testable import AppFramework
@testable import AppFrameworkTests

Current = .mock


let (parent, _) = playgroundControllers(device: .phone5_5inch,
                                        orientation: .portrait,
                                        child: Current.scenes.map)
PlaygroundPage.current.liveView = parent

//: [Next](@next)
