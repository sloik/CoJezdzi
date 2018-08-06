
// Inspiration: https://www.pointfree.co/episodes/ep1-functions

import Foundation


// ForwardApplication < EffectfulComposition < ForwardComposition
//                                           < SingleTypeComposition
//                    <

// MARK: - Pipe forward / Functional Composition

precedencegroup ForwardApplication {
    associativity: left
    higherThan: MultiplicationPrecedence
}

infix operator |>: ForwardApplication

func |> <A, B>(x: A, f: (A) -> B) -> B {
    return f(x)
}

func |> <A>(a: inout A, f: (inout A) -> Void) {
    f(&a)
}


// MARK: - Function Composition
precedencegroup ForwardComposition {
    higherThan: EffectfulComposition
    associativity: right
}

infix operator >>>: ForwardComposition

func >>> <A, B, C>(
    _ f: @escaping (A) -> B,
    _ g: @escaping (B) -> C)
    -> ((A) -> C) {
    return { a in a |> f |> g}
}

precedencegroup BackwardsComposition {
    associativity: left
}
infix operator <<<: BackwardsComposition
public func <<< <A,B,C>(
    _ f: @escaping (B) -> C,
    _ g: @escaping (A) -> B)
    -> (A) -> C {
        return { a in a |> g |> f }
}



// MARK: - Single Type Composytion
precedencegroup SingleTypeComposition {
    associativity: left
    higherThan: EffectfulComposition
}

infix operator <>: SingleTypeComposition

func <> <A>(f: @escaping (A) -> A, g: @escaping (A) -> A) -> (A) -> A {
    return f >>> g
}

func <> <A>(f: @escaping (inout A) -> Void, g: @escaping (inout A) -> Void) -> (inout A) -> Void {
    return { a in
        f(&a)
        g(&a)
    }
}

// MARK: - Fish Operator

precedencegroup EffectfulComposition {
    associativity: left
    higherThan: ForwardApplication
}

// Fish 🐟 operator
infix operator >=>: EffectfulComposition

func >=> <A,B,C>(
    _ f: @escaping (A) -> B?,
    _ g: @escaping (B) -> C?
    ) -> ((A) -> C?) {
    return { a in
        guard let b = a |> f else { return nil }
        return b |> g
    }
}

func >=> <A,B,C>(
    _ f: @escaping (A) -> [B],
    _ g: @escaping (B) -> [C]
    ) -> ((A) -> [C]) {
    return { a in
        let bs = a |> f
        return bs.reduce(into: [C]()) { (accumulator, b) in
            accumulator.append(contentsOf: b |> g)
        }
    }
}

