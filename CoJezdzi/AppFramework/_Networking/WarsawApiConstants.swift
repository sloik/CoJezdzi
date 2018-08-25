import Foundation

enum WarsawApiConstants {
    static let BaseURL     = "https://api.um.warszawa.pl/api/action/busestrams_get"
    static let RefreshRate: TimeInterval = 18.0
    
    static let DateFormatter: Foundation.DateFormatter = {
        let formatter = Foundation.DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter
    }()
    
    enum ParamKey {
        static let APIKey     = "apikey"
        static let ResourceID = "resource_id"
        static let TypeKey    = "type"
    }
    
    enum ParamValue {
        static let ResourceID = "c7238cfe-8b1f-4c38-bb4a-de386db7e776"
        static let TypeTram   = "2"
        static let TypeBus    = "1"
    }
    
    enum EnParamValue: String {
        case ResourceID = "c7238cfe-8b1f-4c38-bb4a-de386db7e776"
        case TypeTram   = "2"
        case TypeBus    = "1"
    }
    
    enum Response {
        struct Key {
            static let Result = "result"
        }
    }
}
