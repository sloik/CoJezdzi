
import ReSwift

func tramsReducer(action: Action, state: TramsState?) -> TramsState {
    var state = state ?? TramsState(data: [])
    
    switch action {
    case let fetchActions as FetchTramsAction:
        state = TramsState(data: fetchActions.fetched)
        
    default:
        break
    }
    
    return state
}
