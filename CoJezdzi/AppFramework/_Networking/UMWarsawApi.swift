import APIKit
import HTTPStatusCodes


protocol UMWarsawRequest: Request {
    
}

extension UMWarsawRequest {
    
    var baseURL: URL {
        guard let url = URL(string: "\(WarsawApiURL.host)/api") else {
            fatalError("Not possible to create url from string: \(WarsawApiURL.host)/api")
        }
        return url
    }

    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        Current.networkLogger.logRequest(urlRequest)
        return urlRequest
    }
    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        Current.networkLogger.logResponse(urlResponse, object: object)
        
        guard let statusCode = HTTPStatusCode(HTTPResponse: urlResponse),
                statusCode.isSuccess else {
            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
        }
        
        return object
    }
}

extension UMWarsawRequest where Response: Decodable {
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        if object is [String: Any] {
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            return try JSONDecoder().decode(Response.self, from: jsonData)
        }
        
        throw ResponseError.unexpectedObject(object)
    }
}
