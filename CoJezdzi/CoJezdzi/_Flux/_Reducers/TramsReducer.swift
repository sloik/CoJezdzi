
import ReSwift

func tramsReducer(action: Action, state: TramsState?) -> TramsState {
    var state = state ?? TramsState(data: [], previousData: [])
    
    switch action {
    case let fetchActions as FetchTramsAction:
        state = TramsState(data: fetchActions.fetched,
                           previousData: state.data)
        
    default:
        break
    }
    
    return state
}
