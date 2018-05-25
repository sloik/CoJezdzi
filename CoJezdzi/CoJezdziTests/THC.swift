
import Foundation

enum Runner {
    static func run(tests: ()...) {
        tests.run()
    }
}

extension Array where Element == Void {
    func run() { self.forEach{ $0 } }
}
