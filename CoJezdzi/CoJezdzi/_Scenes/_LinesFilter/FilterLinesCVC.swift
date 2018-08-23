import UIKit

import ReSwift

class FilterLinesCVC: UICollectionViewController {
    
    fileprivate var latesState: AppState! {
        didSet {
            lines =
                latesState.mapState
                    .allCurrent
                    .reduce(into: Set<String>()) { accu, dto in accu.insert(dto.lines) }
                    .sorted { Int($0) < Int($1) }
            
            refreshVisibleRows()
        }
    }
    
    fileprivate var lines: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Current
            .reduxStore
            .subscribe(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Current
            .reduxStore
            .dispatch(RoutingSceneAppearsAction(scene: .linesFilter, viewController: self))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Current
            .reduxStore
            .unsubscribe(self)
    }
}

// MARK: - Cells Configuration
extension FilterLinesCVC {
    
    func configure(cell: UICollectionViewCell, at indexPath: IndexPath) {
        switch cell {
        case let cell as FilterCollectionViewCell:
            let lineName = lines[indexPath.row]
            cell.labelText = lineName
            cell.active = latesState.settingsState.selectedLines.lines.contains(LineInfo(name: lineName))
            
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
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let selectedLine = lines[indexPath.row]
        if latesState.settingsState.selectedLines.lines.contains(LineInfo(name: selectedLine)) {
            Current
                .reduxStore
                .dispatch(SelectedLineRemoveAction(line: selectedLine))
        } else {
            Current
                .reduxStore
                .dispatch(SelectedLineAddAction(line: selectedLine))
        }
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
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            Current
                .reduxStore
                .dispatch(SelectedLineRemoveAllAction())
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
