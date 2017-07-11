import Foundation

typealias LineInfo = (line: String, active: Bool)

protocol FilerResultHandler: class {
    func selectedLines(_ lines: [String])
}
