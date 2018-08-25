import Foundation

enum Result<T> {
    case succes(T)
    case error(Error)
}

// MARK: - Functions

func succes<T>(_ t: Result<T>) -> T {
    switch t {
    case  .succes(let value): return value
    default: fatalError()
    }
}

func error<T>(_ t: Result<T>) -> Error {
    switch t {
    case .error(let error): return error
        
    default: fatalError()
    }
}
