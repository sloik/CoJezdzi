
import ReSwift

struct FetchTramsAction: Action {
    let fetched: [WarsawTramDto]
    
    static func fetch(state: AppState, store: Store<AppState>) -> FetchTramsAction {
        
        WarsawApi.getTrams { result in
            switch result {
            case .succes(let data):
                print(data)
                store.dispatch(FetchTramsAction(fetched: []))
                
            case .error(let error):
                print(error)
            }            
        }
        
        return FetchTramsAction(fetched: [])
    }
}
