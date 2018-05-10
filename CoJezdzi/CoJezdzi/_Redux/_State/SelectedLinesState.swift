
import ReSwift

struct LineInfo: Hashable {
    let name: String
    
    var hashValue: Int {
        return name.hashValue
    }
}

struct SelectedLinesState: StateType {
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
