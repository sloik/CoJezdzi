//:[ToC](ToC) | [Previous](@previous) | [Next](@next)

import UIKit
import PlaygroundSupport

@testable import AppFramework
@testable import TestsHelpper

import Overture

let window = UIWindow()
App.takeOff(window: window)

//: Arrange
func mockNetworking(_ env: Environment) -> Environment {
    func data(from: WarsawVehicleDto) -> Data {
        let dto = WarsawApiResultDto(result: Array(repeating: from, count: 5))
        let data = try! JSONEncoder().encode(dto)
        return data
    }

    let pipeline:(WarsawVehicleDto) -> Result<Any> = data(from:) >>> Result.succes

    func fakeBusses(completion: @escaping ResultBlock) {
        with(WarsawVehicleDto.mock, set(\WarsawVehicleDto.lines, "255"))
            |> pipeline >>> completion
    }

    func fakeTrams(completion:@escaping ResultBlock) {
        with(.mock, set(\WarsawVehicleDto.lines, "10"))
            |> pipeline >>> completion

    }

    return with(env,
               concat(
                set(\Environment.dataProvider.getBusses, fakeBusses(completion:)),
                set(\Environment.dataProvider.getTrams, fakeTrams(completion:))))
}

Current = .mock
    |> mockNetworking

func runRandomNavigation() {
    DispatchQueue.global(qos: .background).async {
        let action = RoutingAction(destination: RoutingDestination.allCases.randomElement()!)

        DispatchQueue
        .main
        .async { Current.reduxStore.dispatch(action) }

        sleep(UInt32.random(in: 2...4))

        DispatchQueue
            .main
            .async { runRandomNavigation() }
    }
}

runRandomNavigation()



//: Display

let (parent, _) = playgroundControllers(device: .phone5_5inch,
                                        orientation: .portrait,
                                        child: window.rootViewController!)
PlaygroundPage.current.liveView = parent

runRandomNavigation()



//:[ToC](ToC) | [Previous](@previous) | [Next](@next)
