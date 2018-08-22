@testable import CoJezdzi

import Foundation

extension Environment {
    static let mock = Environment(
        dataProvider: .mock
    )

    static let errorMock = Environment(
        dataProvider: .errorMock
    )
}

extension WarsawApi {
    static let mock = WarsawApi(
        getTrams: { completion in completion(.succes(WarsawApiResultDto.mock |> coda))},
        getBusses:{ completion in completion(.succes(WarsawApiResultDto.mock |> coda))})
    
    
    static let errorMock = WarsawApi(
            getTrams: { completion in
                let error = NSError(domain: "mock.error.gettingTrams", code: 69, userInfo: nil)
                completion(.error(error)) },
            
            getBusses:{ completion in
                let error = NSError(domain: "mock.error.gettingBusses", code: 68, userInfo: nil)
                completion(.error(error))})
}

extension WarsawVehicleDto {
    static let mock = WarsawVehicleDto(
        latitude: 22,
        longitude: 33,
        lines: "255",
        brigade: "brigade",
        time: "123")
}

extension WarsawApiResultDto {
    static let mock = WarsawApiResultDto(
        result: [.mock]
    )
}


func coda<C: Codable>(_ c: C) -> Data {
    return try! JSONEncoder().encode(c)
}
