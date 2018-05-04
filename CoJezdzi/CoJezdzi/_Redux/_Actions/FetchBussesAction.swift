
import ReSwift

struct FetchBussesAction: Action {
    let fetched: [WarsawVehicleDto]
    
    static func fetch(state: AppState, store: Store<AppState>) -> FetchBussesAction? {
        WarsawApi.getBusses { result in
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
                    
                    DispatchQueue.main.async {
                        store.dispatch(FetchBussesAction(fetched: withVehicleType))
                    }
                } else {
                    debugPrint(#function + "data: \(String(describing: String(data: data as! Data, encoding: .utf8)))")
                }
                
            case .error(let error):
                print(error)
            }
        }
        
        return nil
    }
}
