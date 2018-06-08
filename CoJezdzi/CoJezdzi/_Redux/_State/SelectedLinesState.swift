
import ReSwift

struct LineInfo: Hashable, Equatable, Codable {
    let name: String
    
    var hashValue: Int {
        return name.hashValue
    }
}

struct SelectedLinesState: StateType, Equatable, Codable {
    let lines: Set<LineInfo>
}

extension SelectedLinesState {
    func add(_ line: LineInfo) -> SelectedLinesState {
        return SelectedLinesState(lines: lines.union([line]))
    }
    
    func remove(_ line: LineInfo) -> SelectedLinesState {
        return SelectedLinesState(lines: lines.subtracting([line]))
    }
}
