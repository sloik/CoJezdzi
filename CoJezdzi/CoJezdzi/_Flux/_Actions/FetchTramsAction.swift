
import ReSwift

struct FetchTramsAction: Action {
    let fetched: [WarsawTramDto]
    
    static func fetch(state: AppState, store: Store<AppState>) -> FetchTramsAction {
        return FetchTramsAction(fetched: [])
    }
}
