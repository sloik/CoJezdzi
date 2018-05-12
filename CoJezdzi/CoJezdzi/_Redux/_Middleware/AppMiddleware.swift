
import ReSwift

struct M {
    static let logging: Middleware<Any> = { dispatch, getState in
        return { next in
            return { action in
                // perform middleware logic
                debugPrint("- - - - " + #function + " - - - - -")
                debugPrint(String(describing: action.self))

                // call next middleware
                return next(action)
            }
        }
    }
    
    enum BS{
        static let dontGetTrams: Middleware<AppState> = { dispatch, getState in
            return { next in
                return { action in
                    
                    // drops action
                    if let state = getState(),
                        state.settingsState.switches.busOnly.isOn && action is FetchTramsAction {
                        return
                    }
                    
                    // call next middleware
                    return next(action)
                }
            }
        }
    }
}

