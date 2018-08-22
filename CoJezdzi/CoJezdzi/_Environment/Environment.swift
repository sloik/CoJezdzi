
import Foundation

struct Environment {
    var dataProvider: DataProviderProtocol = WarsawApi()
}

var Current = Environment()
