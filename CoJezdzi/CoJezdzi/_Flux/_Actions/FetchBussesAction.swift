
import ReSwift

struct FetchBussesAction: Action {
    let fetched: [WarsawTramDto]
    
    static func fetch(state: AppState, store: Store<AppState>) -> FetchBussesAction {
        return FetchBussesAction(fetched: [])
    }
}
