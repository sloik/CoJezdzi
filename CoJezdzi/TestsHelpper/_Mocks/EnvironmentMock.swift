@testable import AppFramework

import Foundation

extension Environment {
    public static let mock = Environment(
        dataProvider: .mock,
        reduxStore: Current.reduxStore,
        persistance: .mock,
        scenes: Current.scenes,
        router: Current.router,
        userDefaults: .mock,
        constants: Constants(),
        useCaseFactory: UseCaseFactory())
    

    public static let errorMock = Environment(
        dataProvider: .errorMock,
        reduxStore: Current.reduxStore,
        persistance: .mock,
        scenes: Current.scenes,
        router: Current.router,
        userDefaults: UserDefaults(),
        constants: Constants(),
        useCaseFactory: UseCaseFactory())
}

extension UserDefaults {
    static let mock = UserDefaults()
}
