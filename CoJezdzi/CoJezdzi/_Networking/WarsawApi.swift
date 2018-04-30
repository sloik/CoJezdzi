
import Foundation

private typealias pKey = WarsawApiConstants.ParamKey
private typealias pValue = WarsawApiConstants.ParamValue

struct WarsawApi {
    static func getTrams(completion: @escaping (Any?) -> Void) {
        
        let urlComponents = NSURLComponents(string: WarsawApiConstants.BaseURL)!
        urlComponents.queryItems = [URLQueryItem(name: pKey.ResourceID, value: pValue.ResourceID),
                                    URLQueryItem(name: pKey.APIKey, value: pValue.APIKey),
                                    URLQueryItem(name: pKey.TypeKey, value: pValue.TypeTram)]
        
        let url = urlComponents.url!
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = C.Networking.HTTPMethod.POST
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            completion(data)
        }
        
        task.resume()
    }
}


