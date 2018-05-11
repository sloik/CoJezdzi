import UIKit

import ReSwift

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

class FilterLinesCVC: UICollectionViewController {
    
    fileprivate var latesState: AppState! {
        didSet {            
            lines =
            latesState.mapSceneState
                .allCurrent
                .reduce(into: Set<String>()) { accu, dto in accu.insert(dto.lines) }
                .sorted { Int($0) < Int($1) }
            
            refreshVisibleRows()
        }
    }
    
    fileprivate var lines: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        store.subscribe(self)
        
        store.dispatch(RoutingAction(destination: .linesFilter))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 3
        store.unsubscribe(self)
    }
}

// MARK: - Cells Configuration
extension FilterLinesCVC {
    
    func configure(cell: UICollectionViewCell, at indexPath: IndexPath) {
        switch cell {
        case let cell as FilterCollectionViewCell:
            let lineName = lines[indexPath.row]
            cell.labelText = lineName
            cell.active = latesState.settingsSceneState.selectedLines.lines.contains(LineInfo(name: lineName))
            
        default: break
        }
    }
    
    func refreshVisibleRows() {
        guard let collectionView = collectionView else { return }
        
        collectionView.indexPathsForVisibleItems.forEach {
            configure(cell: collectionView.cellForItem(at: $0)!, at: $0 )
        }
        
        collectionView.reloadData()
    }
}

// MARK: - Data Source

extension FilterLinesCVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lines.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: C.Storyboard.CellReuseId.FilterLinesCell,
                                                      for: indexPath)
        
        configure(cell: cell, at: indexPath)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FilterLinesCVC {
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // TODO: dispatch action
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // TODO: dispatch action
        collectionView.reloadData()
    }
}

// MARK: - User Interaction
extension FilterLinesCVC {

    @IBAction func userDidTapDoneButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    override var canBecomeFirstResponder : Bool {
        return true
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            // TODO: fire CLEAR_ALL_ACTION and let tehe reducer do the work :D
            collectionView?.reloadData()
        }
    }
}

// MARK: ReSwift

extension FilterLinesCVC: StoreSubscriber {
    func newState(state: AppState) {
        latesState = state
    }
}

// MARK: -
