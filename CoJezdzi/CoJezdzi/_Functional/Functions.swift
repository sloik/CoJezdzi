
import Foundation

// MARK: - Common

public func id<A>(_ a: A) -> A { return a }

public func curry<A,B,C>(
    _ f: @escaping (A, B) -> C)
    -> (A) -> (B) -> C {
        
        return { a in { b in f(a, b) } }
}

public func zurry<A>(_ f: () -> A) -> A {
    return f()
}

// MARK: - Flip

public func flip<A,B,C>( // flip
    _ f: @escaping (A) -> (B) -> (C))
    -> (B) -> (A) -> C {
        return { b in { a in  f(a)(b) } }
}


public func flip<A,C>( // flip
    _ f: @escaping (A) -> () -> (C))
    -> () -> (A) -> C {
        return { { a in f(a)() } }
}

// MARK: - Setters Getters

public func prop<Root, Value>(_ kp: WritableKeyPath<Root, Value>)
    -> (@escaping (Value) -> (Value))
    -> (Root) -> Root {
        return { update in
            return { root in
                var copy = root
                copy[keyPath: kp] = update(copy[keyPath: kp])
                
                return copy
            }
        }
}

public func get<Root, Value>(_ kp: KeyPath<Root, Value>) -> (Root) -> Value {
    return { root in
        root[keyPath: kp]
    }
}


// MARK: - Map

public func map<A,B>(_ f: @escaping (A) -> B) -> ([A]) -> [B] {
    return { xs in xs.map(f) }
}

public func map<A,B>(_ f: @escaping (A) -> B) -> (A?) -> B? {
    return { a in a.map(f) }
}

// MARK: - Filter

public func filter<A>(_ p: @escaping (A) -> Bool) -> ([A]) -> [A] {
    return { xs in xs.filter(p) }
}
