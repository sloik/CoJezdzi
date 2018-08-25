
import Foundation

@testable import AppFramework

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
