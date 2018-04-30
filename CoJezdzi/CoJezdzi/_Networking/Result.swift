import Foundation

enum Result<T> {
    case succes(T)
    case error(Error)
}
