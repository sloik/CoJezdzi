
import Foundation

import ReSwift
import APIKit

struct Environment {
    var reduxStore = Store<AppState>(reducer: appReducer, state: nil, middleware: [AppMiddleware.Api])
    var persistance = Persistence()
    var scenes = Scenes()
    var router = GamePlayAppRouter()
    var userDefaults = UserDefaults.standard
    var networkSession = Session.shared
    var networkLogger = NetworkLogger()
}

var Current = Environment()
