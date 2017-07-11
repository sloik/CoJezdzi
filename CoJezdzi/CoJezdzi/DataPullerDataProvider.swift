import Foundation

typealias JsonDictionary = [String:AnyObject]
typealias FullDataPullingCompletion = (_ trams:[TData], _ busses:[TData])->()

protocol DataPullerDataProvider {
    
    var refreshRate: TimeInterval { get }
    var dateFormatter: DateFormatter { get }
    var apiBaseUrl: String { get }
    
    func getLastFetchedData(_ completion: @escaping FullDataPullingCompletion)
    func getTramsAndBusData(_ completion: @escaping FullDataPullingCompletion)
    
    func date(from formatedTime:String) -> Date?
}

extension DataPullerDataProvider {
    func date(from formatedTime:String) -> Date? {
        let date = dateFormatter.date(from: formatedTime)
        return date
    }
}
