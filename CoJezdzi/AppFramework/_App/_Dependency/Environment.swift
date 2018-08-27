
import Foundation

import ReSwift

struct Environment {
    private(set) var dataProvider = WarsawApi()
    private(set) var reduxStore = Store<AppState>(reducer: appReducer, state: nil, middleware: [M.Api])
    private(set) var persistance = Persistence()
    private(set) var scenes = Scenes()
    private(set) var router = GamePlayAppRouter()
    private(set) var userDefaults = UserDefaults.standard
    
    private(set) var constants = C()
}

var Current = Environment()
