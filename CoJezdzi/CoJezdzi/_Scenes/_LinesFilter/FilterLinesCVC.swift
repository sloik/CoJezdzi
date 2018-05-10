import UIKit

import ReSwift

class FilterLinesCVC: UICollectionViewController {
    
    fileprivate var latesState: SettingsState! {
        didSet {
            refreshVisibleRows()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        store.subscribe(self) {
            $0.select{ (appState) in
                appState.settingsSceneState
            }
        }
        
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
            cell.labelText = "dasda"
            cell.active = true
            
        default: break
        }
    }
    
    func refreshVisibleRows() {
        guard let collectionView = collectionView else { return }
        
        collectionView.indexPathsForVisibleItems.forEach {
            configure(cell: collectionView.cellForItem(at: $0)!, at: $0 )
        }        
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
    func newState(state: SettingsState) {
        latesState = state
    }
}

// MARK: -
