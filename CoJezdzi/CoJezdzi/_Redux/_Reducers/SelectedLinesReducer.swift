
import ReSwift

func selectedStateReducer(action: Action, state: SelectedLinesState?) -> SelectedLinesState {
    let state = state ?? SelectedLinesState(lines: [])
    
    switch action {
    case let action as SelectedLineAddAction:
        return state.add(LineInfo(name: action.line))
        
    case let action as SelectedLineRemoveAction:
        return state.remove(LineInfo(name: action.line))
        
    default:
        return state
    }    
}
