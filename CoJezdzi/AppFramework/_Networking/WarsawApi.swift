
import Overture

// MARK: - Public

typealias ResultBlock = (Result<Any>) -> Void

struct WarsawApi {
    var getTrams = getTrams(completion:)
    var getBusses = getBusses(completion:)
}


// MARK: - Implementation Details

private func getTrams(completion: @escaping ResultBlock) {
    URLSession
        .shared
        .dataTask(with: urlRequest(for: .TypeTram), completionHandler: handler(with: completion))
        .resume()
}

private func getBusses(completion: @escaping ResultBlock) {
    URLSession
        .shared
        .dataTask(with: urlRequest(for: .TypeBus), completionHandler:  handler(with: completion))
        .resume()
}


// MARK: - File Private

fileprivate func urlRequest(for resource: WarsawApiConstants.EnParamValue) -> URLRequest {
    let request = WarsawApiConstants.BaseURL
         |> urlComponents
        >>> set(\.queryItems, queryItems(resource))
        >>> get(\NSURLComponents.url!)
        >>> NSMutableURLRequest.init(url:)
        >>> set(\.httpMethod, C.Networking.HTTPMethod.POST)
    
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
