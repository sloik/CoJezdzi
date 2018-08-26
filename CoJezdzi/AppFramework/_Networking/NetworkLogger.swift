import Foundation

class NetworkLogger {
    class func logRequest(_ request: URLRequest, enabled: Bool = true) {
        guard enabled else {
            return
        }
        
        let headerString = request.allHTTPHeaderFields?.headerString()
        let httpBodyString = String(data: request.httpBody ?? Data(), encoding: .utf8) ?? ""
        
        print("""
            ###[HTTP-Request-start]
            URL: \(request.url?.absoluteString ?? "")
            Method:\(request.httpMethod ?? "")
            \(headerString ?? "")
            \(httpBodyString)
            ###[HTTP-Request-end]
            """)
    }
    
    class func logResponse(_ response: HTTPURLResponse, object: Any, enabled: Bool = true) {
        guard enabled else {
            return
        }
        
        let headerString = (response.allHeaderFields as? [String: String])?.headerString()
        
        print("""
            ###[HTTP-Response-start]
            URL: \(response.url?.absoluteString ?? "")
            Status code:\(response.statusCode)
            \(headerString ?? "")
            \(object)
            ###[HTTP-Response-end]
            """)
    }
}

private extension Dictionary where Key == String, Value == String {
    func headerString() -> String {
        return sorted(by: { $0.0 < $1.0 }).reduce("", {
            $0 + "   \($1.0) = \($1.1) \n"
        })
    }
}
