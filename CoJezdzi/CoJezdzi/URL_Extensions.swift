import Foundation

extension URL {
    func NSURLByAppending(queryParameters : Dictionary<String, String>) -> Foundation.URL {
        
        let queryItems: [NSURLQueryItem] = queryParameters.map { (key: String, value: String) -> NSURLQueryItem in
            return NSURLQueryItem.init(name: key, value: value)
        }
        
        var compontnets = URLComponents.init(url: self, resolvingAgainstBaseURL: false)!
        compontnets.queryItems = queryItems as [URLQueryItem]
        
        return compontnets.url!
    }
}
