
import Foundation

public enum Runner {
    public static func run(tests: ()...) {
        tests.run()
    }
}

public extension Array where Element == Void {
    func run() { self.forEach{ $0 } }
}

public func encodeDecode<TestedType: Codable>(_ object: TestedType) throws -> TestedType {
    return try JSONDecoder().decode(TestedType.self, from: coda(object))
}

public func coda<C: Codable>(_ c: C) -> Data {
    return try! JSONEncoder().encode(c)
}
