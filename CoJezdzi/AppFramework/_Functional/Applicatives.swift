
import Foundation

// Defines `apply` function for types.
// http://www.mokacoding.com/blog/functor-applicative-monads-in-pictures/

extension Optional {
    func apply<U>(_ f: ((Wrapped) -> U?)?) -> U? {
        return f.flatMap { f in return self.flatMap(f) }
    }
}
