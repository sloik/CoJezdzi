import ReSwift
import APIKit
import RxSwift
import RxCocoa

private struct FetchAction: Action {
    let request: UMWarsawTransportApi.GetRealtimeDataRequest
    let resultFactory: ([WarsawVehicleDto]) -> Action
}

struct AppMiddleware {
    
    static let Api: Middleware<AppState> = { dispatch, getState in
        return { next in
            return { action in
                guard action is FetchVehiclesPosytionsAction, let state = getState() else {
                    next(action)
                    return
                }
                
                let actions = fetchActions(for: state.settingsState)
                Observable.from(actions)
//                    .map { fetchAction in
//                        let request = fetchAction.request
//                        Current.networkSession.rx.response(request)
//                            .subscribe { result in
//                                switch result {
//                                case .next(let response):
//                                    let action = fetchAction.resultFactory(response.result)
//                                    dispatch(action)
//                                case .error(let error):
//                                    print(error.localizedDescription)
//                                case .completed: break
//                                }
//                            }
//                    }
                    .flatMap { fetchAction -> Observable<UMWarsawTransportApi.GetRealtimeDataRequest.Response> in
                        let request = fetchAction.request
                        return Current.networkSession.rx.response(request)
                    }
                    .subscribe { result in
                        switch result {
                        case .next(let response):
                            let action = actions.filter { $0.request.type }
                            dispatch(action as! Action)
                        case .error(let error):
                            print(error.localizedDescription)
                        case .completed: break
                        }
                    }
            }
        }
    }
    
    fileprivate static func fetchActions(for settingsState: SettingsState) -> [FetchAction] {
        let busOnly  = settingsState.switches.busOnly.isOn
        let tramOnly = settingsState.switches.tramOnly.isOn
        var actions = [FetchAction]()
        
        if busOnly  || tramOnly == false {
            let request = UMWarsawTransportApi.GetRealtimeDataRequest(vehicleType: .bus)
            let resultAction = { return FetchBussesAction(fetched: $0) }
            let action = FetchAction(request: request, resultFactory: resultAction)
            actions.append(action)
        }
        
        if tramOnly || busOnly  == false {
            let request = UMWarsawTransportApi.GetRealtimeDataRequest(vehicleType: .tram)
            let resultAction = { return FetchBussesAction(fetched: $0) }
            let action = FetchAction(request: request, resultFactory: resultAction)
            actions.append(action)
        }
        
        return actions
    }
}

///// old version
//
//struct M {
//
//    static let Api: Middleware<AppState> = { dispatch, getState in
//        return { next in
//            func handleResult(result: Result<Any>, actionFactory: (([WarsawVehicleDto]) -> Action), dispatch: @escaping DispatchFunction) {
//                switch result {
//                case .succes(let data):
//                    if let dto = try? JSONDecoder().decode(WarsawApiResultDto.self, from: data as! Data) {
//
//                        let withVehicleType = dto
//                            .result
//                            .map{ WarsawVehicleDto(latitude: $0.latitude,
//                                                   longitude: $0.longitude,
//                                                   lines: $0.lines,
//                                                   brigade: $0.brigade,
//                                                   time: $0.time) }
//
//                        let action = actionFactory(withVehicleType)
//                        DispatchQueue.main.async {
//                            dispatch(action)
//                        }
//                    } else {
//                        debugPrint(#function + "data: \(String(describing: String(data: data as! Data, encoding: .utf8)))")
//                    }
//                case .error(let error):
//                    print(error)
//                }
//            }
//
//            return { action in
//                guard action is FetchVehiclesPosytionsAction, let state = getState() else {
//                    next(action)
//                    return
//                }
//
//                let busOnly  = state.settingsState.switches.busOnly.isOn
//                let tramOnly = state.settingsState.switches.tramOnly.isOn
//
//                let fetchBusses = busOnly  || tramOnly == false
//                let fetchTrams  = tramOnly || busOnly  == false
//
//                let bussesFactory = { return FetchBussesAction(fetched: $0) }
//                let tramsFactory =  { return FetchTramsAction(fetched: $0) }
//
//                if fetchTrams {
//                    Current
//                        .dataProvider
//                        .getTrams { handleResult(result: $0, actionFactory: tramsFactory, dispatch: dispatch) }
//                }
//
//                if fetchBusses {
//                    Current
//                        .dataProvider
//                        .getBusses { handleResult(result: $0, actionFactory: bussesFactory, dispatch: dispatch) }
//                }
//            }
//        }
//    }
//}
