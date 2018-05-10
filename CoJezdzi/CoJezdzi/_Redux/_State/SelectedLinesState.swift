
import ReSwift

struct LineInfo: Hashable {
    let name: String
    
    var hashValue: Int {
        return name.hashValue
    }
}

struct SelectedLinesState: StateType {
    let selectedLines: Set<LineInfo>
}

extension SelectedLinesState {
    func add(_ line: LineInfo) -> SelectedLinesState {
        return SelectedLinesState(selectedLines: selectedLines.union([line]))
    }
    
    func remove(_ line: LineInfo) -> SelectedLinesState {
        return SelectedLinesState(selectedLines: selectedLines.subtracting([line]))
    }
}
