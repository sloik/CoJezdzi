
import Foundation

import ReSwift

struct Environment {
    var dataProvider = WarsawApi()
    var reduxStore = Store<AppState>(reducer: appReducer, state: nil, middleware: [M.Api])
    var persistance = Persistence()
    var scenes = Scenes()
    var router = GamePlayAppRouter()
    var userDefaults = UserDefaults.standard
}

var Current = Environment()
