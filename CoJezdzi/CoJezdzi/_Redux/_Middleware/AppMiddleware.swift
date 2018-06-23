
import ReSwift

struct M {
    static func handleResult(result: Result<Any>, actionFactory: (([WarsawVehicleDto]) -> Action), dispatch: @escaping DispatchFunction) {
        switch result {
        case .succes(let data):
            if let dto = try? JSONDecoder().decode(WarsawApiResultDto.self, from: data as! Data) {
                
                let withVehicleType =
                    dto.result.map{ WarsawVehicleDto(latitude: $0.latitude,
                                                     longitude: $0.longitude,
                                                     lines: $0.lines,
                                                     brigade: $0.brigade,
                                                     time: $0.time,
                                                     type: .bus) }
                
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
    
    static let Api: Middleware<AppState> = { dispatch, getState in
        return { next in
            
            return { action in
                switch action {
                case is FetchVehiclesPosytionsAction:
                    guard let state = getState() else { return }
                    
                    let busOnly  = state.settingsState.switches.busOnly.isOn
                    let tramOnly = state.settingsState.switches.tramOnly.isOn
                    
                    if busOnly || tramOnly == false {
                        // get buses
                        WarsawApi.getBusses { result in
                            
                            handleResult(result: result,
                                         actionFactory: { return FetchBussesAction(fetched: $0) },
                                         dispatch: dispatch)
                        }
                    }
                    
                    if tramOnly || busOnly == false {
                        WarsawApi.getTrams { result in
                            
                            handleResult(result: result,
                                         actionFactory: { return FetchTramsAction(fetched: $0) },
                                         dispatch: dispatch)
                        }
                    }
                    
                default:
                    return next(action)
                }
            }
        }
    }
}
