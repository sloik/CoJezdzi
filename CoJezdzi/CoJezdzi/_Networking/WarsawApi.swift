
import Foundation

import Overture

// MARK: - Public

typealias ResultBlock = (Result<Any>) -> Void

struct WarsawApi {
    static func getTrams(completion: @escaping ResultBlock) {
        URLSession
            .shared
            .dataTask(             with: .TypeTram  |> urlRequest(for:),
                      completionHandler: completion |> handler(with:))
            .resume()
    }
    
    static func getBusses(completion: @escaping ResultBlock) {
        URLSession
            .shared
            .dataTask(             with: .TypeBus   |> urlRequest(for:),
                      completionHandler: completion |> handler(with:))
            .resume()
    }
}

// MARK: - File Private

fileprivate func urlRequest(for resource: WarsawApiConstants.EnParamValue) -> URLRequest {
    let request = WarsawApiConstants.BaseURL
        |> urlComponents
        >>> (prop(\NSURLComponents.queryItems)) { _ in queryItems(resource) }
        >>> get(\NSURLComponents.url!)
        >>> NSMutableURLRequest.init(url:)
        >>> (prop(\NSMutableURLRequest.httpMethod)) { _ in C.Networking.HTTPMethod.POST }
    
    return request as URLRequest
}

fileprivate func urlComponents(_ url: String) -> NSURLComponents {
    return NSURLComponents(string: url)!
}

fileprivate func queryItems(_ type: WarsawApiConstants.EnParamValue) -> [URLQueryItem] {
    return [URLQueryItem(name: pKey.ResourceID, value: pValue.ResourceID),
            URLQueryItem(name: pKey.APIKey, value: pValue.APIKey),
            URLQueryItem(name: pKey.TypeKey, value: type.rawValue)]
}

fileprivate func handler(with c: @escaping ResultBlock)
    -> (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void {
        return { (d, r, e) in
            responseHandler(data: d, response: r, error: e, completion: c)
        }
}

fileprivate func responseHandler(data: Data?,
                                 response: URLResponse?,
                                 error: Error?,
                                 completion: ResultBlock) {
    if let error = error  {
        defer { completion(.error(error)) }
        return
    }
    
    completion(.succes(data as Any))
}

// MARK: - Private

private typealias pKey = WarsawApiConstants.ParamKey
private typealias pValue = WarsawApiConstants.ParamValue
