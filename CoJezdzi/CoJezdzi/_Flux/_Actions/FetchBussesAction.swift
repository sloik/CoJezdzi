
import ReSwift

struct FetchBussesAction: Action {
    let fetched: [WarsawVehicleDto]
    
    static func fetch(state: AppState, store: Store<AppState>) -> FetchBussesAction {
        return FetchBussesAction(fetched: [])
    }
}
