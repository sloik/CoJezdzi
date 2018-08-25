@testable import AppFramework

import ReSwift
import Overture


let mockDispatch: (Action) -> Void = { action in
    debugPrint("💎: \(#function): \(action) ")
    return
}

func mockGetState() -> AppState? {
    debugPrint("☕️: \(#function)")
    return .mock
}

let mockActionHandler = { (action: Action) in
    debugPrint("💩 \(#function) \(action)")
    return
}

func test(action: Action,  middleware: Middleware<AppState>) {
    // ReSwift Middleware has a lot of curried functions. So to help a bit with tests ;)
    middleware(mockDispatch, mockGetState)(mockActionHandler)(action)
}
