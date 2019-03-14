
import ReSwift

extension Environment {
    public static let mock = Environment(
        dataProvider: .mock,
        reduxStore:   Store<AppState>(reducer: appReducer, state: .mock, middleware: [M.Api]),
        persistance: .mock,
        scenes: Current.scenes,
        router: Current.router,
        userDefaults: .mock,
        constants: Constants(),
        useCaseFactory: UseCaseFactory())
    

    public static let errorMock = Environment(
        dataProvider: .errorMock,
        reduxStore: Store<AppState>(reducer: appReducer, state: .mock, middleware: [M.Api]),
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
