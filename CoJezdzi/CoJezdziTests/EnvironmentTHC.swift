@testable import CoJezdzi

import Foundation

extension Environment {
    static let mock = Environment(
        dataProvider: WarsawApi.succesMock
    )

    static let errorMock = Environment(
        dataProvider: WarsawApi.errorMock
    )
}

extension WarsawApi {
    static let succesMock = WarsawApi(
        getTrams: { completion in completion(Result.succes(Data())) },
        getBusses:{ completion in completion(Result.succes(Data()))})
    
    
    static let errorMock = WarsawApi(
            getTrams: { completion in
                let error = NSError(domain: "mock.error.gettingTrams", code: 69, userInfo: nil)
                completion(Result.error(error)) },
            
            getBusses:{ completion in
                let error = NSError(domain: "mock.error.gettingBusses", code: 68, userInfo: nil)
                completion(Result.error(error))})
}
