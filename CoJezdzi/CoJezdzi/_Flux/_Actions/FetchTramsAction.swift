
import ReSwift

struct FetchTramsAction: Action {
    let fetched: [WarsawTramDto]
    
    static func fetch(state: AppState, store: Store<AppState>) -> FetchTramsAction {
        
        WarsawApi.getTrams { result in
            // TODO: map result to expected type
            print(#function)
            store.dispatch(FetchTramsAction(fetched: []))
        }
        
        return FetchTramsAction(fetched: [])
    }
}
