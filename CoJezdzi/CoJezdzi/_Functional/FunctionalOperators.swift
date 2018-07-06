
// Inspiration: https://www.pointfree.co/episodes/ep1-functions

import Foundation

// MARK: - Pipe forward / Functional Composition

precedencegroup ForwardApplication {
    associativity: left
}

infix operator |>: ForwardApplication

func |> <A, B>(x: A, f: (A) -> B) -> B {
    return f(x)
}


// MARK: - Function Composition
precedencegroup ForwardComposition {
    higherThan: ForwardApplication
    associativity: right
}

infix operator >>>: ForwardComposition

func >>> <A, B, C>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> C) -> ((A) -> C) {
    return { a in g(f(a)) }
}
