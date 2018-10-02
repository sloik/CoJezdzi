import APIKit

final class UMWarsawTransportApi {
    
    private init() {
    }
    
    struct GetRealtimeDataRequest: UMWarsawRequest {
        
        let vehicleType: WarsawVehicleType

        // MARK: RequestType
        typealias Response = UMWarsawTransportResponse
        
        var method: HTTPMethod {
            return .post
        }
        
        var path: String {
            return "/action/busestrams_get/"
        }
        
        var queryParameters: [String: Any]? {
            return [
                "apikey": WarsawApiConstants.ParamValue.APIKey,
                "resource_id": "c7238cfe-8b1f-4c38-bb4a-de386db7e776",
                "type": vehicleType.type,
            ]
        }
        
    }
}
