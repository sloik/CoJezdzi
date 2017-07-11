
import Foundation

import HTTPStatusCodes
import PromiseKit
import Unbox

//    • Time - datetime - znacznik czasu
//    • Lat - float - szerokość geograficzna GPS
//    • Lon - float - długość geograficzna GPS
//    • FirstLine - string - numer pierwszej realizowanej linii
//    • Lines - string - numery wszystkich linii (dla brygad wieloliniowych pojawi się więcej
//    niż jedna linia)
//    • Brigade - string - numer brygady
//    • Status - string - status zadania może przyjmować wartości "RUNNING" i "FINISHED"
//    • LowFloor - bool - określenie czy zadanie realizuje tramwaj niskopodłogowy 1 - Tak, 0 - Nie

// Response
//{
//    "Lat": 52.2366409,
//    "Lines": "35",
//    "Brigade": "8",
//    "Lon": 21.0076237,
//    "Time": "2017-04-10 20:16:16"
//},

struct WarsawAPI {
    static let BaseURL     = "https://api.um.warszawa.pl/api/action/busestrams_get"
    static let RefreshRate: TimeInterval = 18.0
    
    static let DateFormatter: Foundation.DateFormatter = {
        let formatter = Foundation.DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter
    }()
    
    struct ParamKey {
        static let APIKey     = "apikey"
        static let ResourceID = "resource_id"
        static let TypeKey    = "type"
    }
    
    struct ParamValue {
        static let APIKey     = "YOUR_WARSAW_API_API_KEY"
        static let ResourceID = "c7238cfe-8b1f-4c38-bb4a-de386db7e776"
        static let TypeTram   = "2"
        static let TypeBus    = "1"
    }
    
    struct Response {
        struct Key {
            static let Result = "result"
        }
    }
}

class WarsawApiDealer: DataPullerDataProvider {
    
    private var trams:[TData] = []
    private var busses:[TData] = []
    
    fileprivate let responseParser = WarsawApiResponseParser()
    
    var refreshRate: TimeInterval { return WarsawAPI.RefreshRate }
    
    var dateFormatter: DateFormatter { return WarsawAPI.DateFormatter }
    
    var apiBaseUrl: String { return WarsawAPI.BaseURL }
    
    func getTramsAndBusData(_ completion: @escaping FullDataPullingCompletion) {
        when(fulfilled: getBusData(), getTramData()).then { (busData:[TData], tramData:[TData]) in
            completion(tramData, busData)
        }.catch {_ in
            self.trams = []
            self.busses = []
            
            completion([], [])
        }
    }
    
    func getLastFetchedData(_ completion: @escaping FullDataPullingCompletion) {
        completion(trams, busses)
    }
    
    private func getBusData() -> Promise<[TData]> {

        return Promise { fulfill, reject in
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            
            var URL = Foundation.URL(string: WarsawAPI.BaseURL)
            let URLParams = [
                WarsawAPI.ParamKey.ResourceID: WarsawAPI.ParamValue.ResourceID,
                WarsawAPI.ParamKey.APIKey    : WarsawAPI.ParamValue.APIKey,
                WarsawAPI.ParamKey.TypeKey   : WarsawAPI.ParamValue.TypeBus
            ]
            
            URL = URL?.NSURLByAppending(queryParameters: URLParams)
            
            let request = NSMutableURLRequest(url: URL!)
            request.httpMethod = C.Networking.HTTPMethod.POST
            
            // Start the task
            let task = session.dataTask(with: request as URLRequest) {
                (data: Data?, response: URLResponse?, err: Error? ) in
                
                let mapping = { (dic: JsonDictionary) throws -> TData in
                    let unboxableDic = dic as UnboxableDictionary
                    var bus = try unbox(dictionary: unboxableDic) as TData
                    bus.type = .Bus
                    
                    return bus
                }
                
                let postMaping = {
                    self.busses = $0
                }
                
                self.responseParser.parseApiData(data: data, response: response, error: err,
                                                 fulfill: fulfill, reject: reject,
                                                 mapping: mapping,
                                                 postMaping: postMaping)
            }
            
            task.resume()
        }
    }
    
    private func getTramData() -> Promise<[TData]> {
        return Promise { fulfill, reject in
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            
            var URL = Foundation.URL(string: WarsawAPI.BaseURL)
            let URLParams = [
                WarsawAPI.ParamKey.ResourceID: WarsawAPI.ParamValue.ResourceID,
                WarsawAPI.ParamKey.APIKey    : WarsawAPI.ParamValue.APIKey,
                WarsawAPI.ParamKey.TypeKey   : WarsawAPI.ParamValue.TypeTram
            ]
            
            URL = URL?.NSURLByAppending(queryParameters: URLParams)
            
            let request = NSMutableURLRequest(url: URL!)
            request.httpMethod = C.Networking.HTTPMethod.POST
            
            // Start the task
            let task = session.dataTask(with: request as URLRequest) {
                (data: Data?, response: URLResponse?, err: Error? ) in
                
                let mapping = { (dic: JsonDictionary) throws -> TData in
                    let unboxableDic = dic as UnboxableDictionary
                    var tram = try unbox(dictionary: unboxableDic) as TData
                    tram.type = .Tram
                    
                    return tram
                }
                
                let postMaping = {
                    self.trams = $0
                }
                
                self.responseParser.parseApiData(data: data, response: response, error: err,
                                                 fulfill: fulfill, reject: reject,
                                                 mapping: mapping,
                                                 postMaping: postMaping)
            }
            
            task.resume()
        }
    }
}

extension WarsawApiDealer: Copyrightable {
    var copyRightInfo: String? { return "Miasto Stołeczne Warszawa\nhttp://api.um.warszawa.pl\n" }
}
