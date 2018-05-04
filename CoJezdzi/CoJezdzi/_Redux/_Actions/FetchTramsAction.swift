
import ReSwift

struct FetchTramsAction: Action {
    let fetched: [WarsawVehicleDto]
    
    static func fetch(state: AppState, store: Store<AppState>) -> FetchTramsAction? {
        
        WarsawApi.getTrams { result in
            switch result {
            case .succes(let data):
                let dto = try! JSONDecoder().decode(WarsawApiResultDto.self, from: data as! Data)
                
                let withVehicleType =
                    dto.result.map{ WarsawVehicleDto(latitude: $0.latitude,
                                                  longitude: $0.longitude,
                                                  lines: $0.lines,
                                                  brigade: $0.brigade,
                                                  time: $0.time,
                                                  type: .tram) }
                
                DispatchQueue.main.async {
                    store.dispatch(FetchTramsAction(fetched: withVehicleType))
                }
                
            case .error(let error):
                print(error)
            }            
        }
        
        return nil
    }
}
