
import Foundation

import ReSwift

struct AppState: StateType {
    var currentTrams : [WarsawTramDto] = []
    var previousTrams: [WarsawTramDto] = []
}
