import Foundation

struct WarsawApiResponseParser {
    
    func parseApiData(data: Data?,
                      response: URLResponse?,
                      error inError: Error?,
                      fulfill: @escaping ( ([TData]) -> Void ),
                      reject: @escaping ( (Error) -> Void ),
                      mapping: @escaping ( (JsonDictionary) throws -> TData ),
                      postMaping: ( ([TData]) -> Void ),
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line) {
        
        let callSiteString = "\(file) \(function) \(line)"
        
        // Network
        guard inError == nil else {
            print("Network Error when getting data for: <\(callSiteString)> with error: <\(inError!)>")
            
            reject(inError!)
            return
        }
        
        // Makes sure that we have an HTTP URL Response
        guard let httpResponse = response as? HTTPURLResponse else {
            let userInfo = [
                NSLocalizedFailureReasonErrorKey: "Expected an HTTPURLResponse while getting data for \(callSiteString)"
            ]
            let error = NSError(domain: C.Error.Domain, code: C.Error.Code.WrongUrlResponseType, userInfo: userInfo)
            
            print("Wrong type of response for \(callSiteString)")
            
            reject(error)
            return
        }
        
        // check if has data or the response form server was ok
        guard let jsonData = data, let statusCode = httpResponse.statusCodeValue, statusCode.isSuccess == true else {
            
            let userInfo = [
                NSLocalizedFailureReasonErrorKey: "\(callSiteString) Missing data: \(String(describing: data)) or Server Error: \(String(describing: httpResponse.statusCodeValue))"
            ]
            let error = NSError(domain: C.Error.Domain, code: C.Error.Code.NoDataOrServerError, userInfo: userInfo)
            
            print("\(callSiteString) missing data: \(error)")
            
            reject(error)
            return
        }
        
        // try to parse json
        guard let json = try? JSONSerialization.jsonObject(with: jsonData,
                                                           options: .allowFragments) as? JsonDictionary,
            let apiData = json?[WarsawAPI.Response.Key.Result] as? [JsonDictionary] else {
                
                let userInfo = [
                    NSLocalizedFailureReasonErrorKey: "Unable to parse JSON",
                    NSLocalizedDescriptionKey:        "Unable to parse JSON"
                ]
                let error = NSError(domain: C.Error.Domain, code: C.Error.Code.UnableTo.ParseJson , userInfo: userInfo)
                
                print("Error parsing JSON for \(file): \(function) : \(error)")
                
                reject(error)
                
                return
        }
        
        // map the data
        guard let convertedToTData =  try? apiData.map(mapping) else {
            let userInfo = [
                NSLocalizedFailureReasonErrorKey: "Unable to map api data to TData",
                NSLocalizedDescriptionKey:        "Unable to map api data to TData"
            ]
            let error = NSError(domain: C.Error.Domain, code: C.Error.Code.UnableTo.MapJson , userInfo: userInfo)
            
            print("Error parsing JSON for \(file): \(function) : \(error)")
            
            reject(error)
            
            return
        }
        
        // give a caller a chance to do anything with this data...
        postMaping(convertedToTData)
        
        // done! :D
        fulfill(convertedToTData)
    }
}
