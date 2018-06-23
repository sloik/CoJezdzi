
import ReSwift

struct M {
    
    static let Api: Middleware<AppState> = { dispatch, getState in
        return { next in
            func handleResult(result: Result<Any>, actionFactory: (([WarsawVehicleDto]) -> Action), dispatch: @escaping DispatchFunction) {
                switch result {
                case .succes(let data):
                    if let dto = try? JSONDecoder().decode(WarsawApiResultDto.self, from: data as! Data) {
                        
                        let withVehicleType = dto
                            .result
                            .map{ WarsawVehicleDto(latitude: $0.latitude,
                                                   longitude: $0.longitude,
                                                   lines: $0.lines,
                                                   brigade: $0.brigade,
                                                   time: $0.time) }
                        
                        let action = actionFactory(withVehicleType)
                        DispatchQueue.main.async {
                            dispatch(action)
                        }
                    } else {
                        debugPrint(#function + "data: \(String(describing: String(data: data as! Data, encoding: .utf8)))")
                    }
                case .error(let error):
                    print(error)
                }
            }
            
            return { action in
                guard action is FetchVehiclesPosytionsAction, let state = getState() else {
                    next(action)
                    return
                }
                
                let busOnly  = state.settingsState.switches.busOnly.isOn
                let tramOnly = state.settingsState.switches.tramOnly.isOn
                
                let fetchBusses = busOnly  || tramOnly == false
                let fetchTrams  = tramOnly || busOnly  == false
                
                let bussesFactory = { return FetchBussesAction(fetched: $0) }
                let tramsFactory =  { return FetchTramsAction(fetched: $0) }
                
                if fetchTrams {
                    WarsawApi.getTrams { handleResult(result: $0, actionFactory: tramsFactory, dispatch: dispatch) }
                }
                
                if fetchBusses {
                    WarsawApi.getBusses { handleResult(result: $0, actionFactory: bussesFactory, dispatch: dispatch) }
                }
                
            }
        }
    }
}
