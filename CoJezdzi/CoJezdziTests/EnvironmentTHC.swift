@testable import CoJezdzi

import Foundation

extension Environment {
    static let mock = Environment(
        dataProvider: SuccesDataProviderMock()
    )
    
    static let errorMock = Environment(
        dataProvider: ErrorDataProviderMock()
    )
}

struct SuccesDataProviderMock: DataProviderProtocol {
    func getTrams(completion: @escaping ResultBlock) {
        let error = NSError(domain: "mock.error", code: 69, userInfo: nil)
        completion(Result.error(error))
    }
    
    func getBusses(completion: @escaping ResultBlock) {
        let error = NSError(domain: "mock.error", code: 69, userInfo: nil)
        completion(Result.error(error))
    }
}

struct ErrorDataProviderMock: DataProviderProtocol {
    func getTrams(completion: @escaping ResultBlock) {
        let error = NSError(domain: "mock.error", code: 69, userInfo: nil)
        completion(Result.error(error))
    }
    
    func getBusses(completion: @escaping ResultBlock) {
        let error = NSError(domain: "mock.error", code: 69, userInfo: nil)
        completion(Result.error(error))
    }
}
