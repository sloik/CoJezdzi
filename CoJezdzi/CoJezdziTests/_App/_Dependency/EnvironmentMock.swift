@testable import CoJezdzi

import Foundation

extension Environment {
    
    static let mock = Environment(
        dataProvider: .mock,
        reduxStore: Current.reduxStore,
        persistance: .mock,
        scenes: Current.scenes,
        router: Current.router,
        userDefaults: UserDefaults())
    

    static let errorMock = Environment(
        dataProvider: .errorMock,
        reduxStore: Current.reduxStore,
        persistance: .mock,
        scenes: Current.scenes,
        router: Current.router,
        userDefaults: UserDefaults())
}

func coda<C: Codable>(_ c: C) -> Data {
    return try! JSONEncoder().encode(c)
}
