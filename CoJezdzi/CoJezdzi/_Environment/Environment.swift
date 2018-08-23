
import Foundation

import ReSwift

struct Environment {
    var dataProvider = WarsawApi()
    var reduxStore = Store<AppState>(reducer: appReducer, state: nil, middleware: [M.Api])
}

var Current = Environment()
