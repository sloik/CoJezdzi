
import Foundation

import HTTPStatusCodes
import PromiseKit

// Response
// lastUpdate: 1492884060975,
// vehicles: []
//{
//    id: "6352185295672181157",
//    isDeleted: true
//},
//{
//    id: "6352185295672180837",
//    category: "tram",
//    color: "0x000000",
//    tripId: "6351558574045708313",
//    name: "21 Walcownia",
//    path: [
//        {
//            length: 0.00002246685411490138,
//            y1: 180367040,
//            y2: 180367013,
//            x2: 72044392,
//            angle: 119,
//            x1: 72044315
//        } ... ],
//    longitude: 72045296,
//    latitude: 180365650,
//    heading: 168
//},

struct KrakowAPI {
    static let BaseURL     = "http://www.ttss.krakow.pl/internetservice/geoserviceDispatcher/services/vehicleinfo/vehicles"
    static let RefreshRate = 18.0
    
    static let DateFormatter: Foundation.DateFormatter = {
        let formatter = Foundation.DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter
    }()
    
    struct ParamKey {
        static let PositionType = "positionType"
    }
    
    struct ParamValue {
        static let PositionTypeCorrected = "CORRECTED"
    }
}

class KrakowApiDealer: DataPullerDataProvider {
    
    private var trams:[TData] = []
    private var busses:[TData] = []
    
    fileprivate let responseParser = KrakowApiResponseParser()
    
    var refreshRate: TimeInterval {
        return KrakowAPI.RefreshRate
    }
    
    var dateFormatter: DateFormatter {
        return KrakowAPI.DateFormatter
    }
    
    var apiBaseUrl: String {
        return KrakowAPI.BaseURL
    }
    
    func getTramsAndBusData(_ completion: @escaping FullDataPullingCompletion) {
        getTramData().then { (trams:[TData]) in
            completion(trams, [])
        }.catch { _ in
            self.trams = []
            self.busses = []
            
            completion([], [])
        }
    }
    
    func getLastFetchedData(_ completion: @escaping FullDataPullingCompletion) {
        completion(trams, busses)
    }
    
    private func getTramData() -> Promise<[TData]> {
        return Promise { fulfill, reject in
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            
            var URL = Foundation.URL(string: KrakowAPI.BaseURL)
            let URLParams = [
                KrakowAPI.ParamKey.PositionType : KrakowAPI.ParamValue.PositionTypeCorrected
            ]
            
            URL = URL?.NSURLByAppending(queryParameters: URLParams)
            
            let request = NSMutableURLRequest(url: URL!)
            request.httpMethod = C.Networking.HTTPMethod.POST
            
            // Start the task
            let task = session.dataTask(with: request as URLRequest) {
                (data: Data?, response: URLResponse?, err: Error? ) in
                
                let mapping = { (vehicle: KrakowVehicle) -> TrueVehicle? in
                    if vehicle.isDeleted == nil {
                        return TrueVehicle(vehicle: vehicle)
                    }
                    
                    return  nil
                }
                
                let postMaping = {
                    self.trams = $0
                }
                
                self.responseParser.parseApiData(data: data, response: response, error: err,
                                                 fulfill: fulfill,
                                                 reject: reject,
                                                 mapping: mapping,
                                                 postMaping: postMaping)
            }
            
            task.resume()
        }
    }
}
