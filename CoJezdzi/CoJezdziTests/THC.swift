
import Foundation

enum Runner {
    static func run(tests: ()...) {
        tests.run()
    }
}

extension Array where Element == Void {
    func run() { self.forEach{ $0 } }
}

func encodeDecode<TestedType: Codable>(_ object: TestedType) throws -> TestedType {
    return try JSONDecoder().decode(TestedType.self, from: coda(object))
}

func coda<C: Codable>(_ c: C) -> Data {
    return try! JSONEncoder().encode(c)
}
