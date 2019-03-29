
import ReSwift

struct LineInfo: Hashable, Equatable, Codable {
    let name: String
    
//    var hashValue: Int {
//        return name.hashValue
//    }
}

struct SelectedLinesState: StateType, Equatable, Codable {
    var lines: Set<LineInfo>
}
