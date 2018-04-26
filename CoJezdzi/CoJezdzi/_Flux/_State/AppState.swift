
import Foundation

import ReSwift

struct State: StateType {
    var currentTrams : [WarsawTramDto] = []
    var previousTrams: [WarsawTramDto] = []
}
