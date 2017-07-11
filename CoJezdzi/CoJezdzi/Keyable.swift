import Foundation

public protocol Keyable {
    var keyID: String { get }
}

extension Keyable {
    var hashValue: Int {
        return self.keyID.hashValue
    }
}
