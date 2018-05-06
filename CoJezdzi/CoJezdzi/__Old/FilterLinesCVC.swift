import UIKit

class FilterLinesCVC: UICollectionViewController {

    let cellReuseID = C.Storyboard.CellReuseId.FilterLinesCell

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath)
    
        // Configure the cell

        if let filterCell = cell as? FilterCollectionViewCell {
//            let currentLineInfo = linesToSelect[indexPath.row]
//            filterCell.labelText = currentLineInfo.line
//            filterCell.active = currentLineInfo.active
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
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
