import UIKit

class FilterLinesCVC: UICollectionViewController {

    var linesToSelect: [LineInfo] = []
    weak var resultHandler: FilerResultHandler?

    let cellReuseID = C.Storyboard.CellReuseId.FilterLinesCell

    var selectedLines: [String] {
        return linesToSelect.filter { lineInfo in lineInfo.active }
                            .map    { lineInfo in lineInfo.line }
    }

    fileprivate func notifyResultHandler() {
        if let resultHandler = resultHandler {
            resultHandler.selectedLines(selectedLines)
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return linesToSelect.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath)
    
        // Configure the cell

        if let filterCell = cell as? FilterCollectionViewCell {
            let currentLineInfo = linesToSelect[indexPath.row]
            filterCell.labelText = currentLineInfo.line
            filterCell.active = currentLineInfo.active
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateModel(at: indexPath, didSelect: false)
        collectionView.reloadData()
        notifyResultHandler()
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        updateModel(at: indexPath)
        collectionView.reloadData()

        notifyResultHandler()
    }
}

// MARK: - Helppers
extension FilterLinesCVC {
    func updateModel(at indexPath: IndexPath, didSelect: Bool = true) {
        let (line, active) = linesToSelect[indexPath.row]
        linesToSelect[indexPath.row] = (line,
                                        didSelect ? !active : false)
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
            linesToSelect = linesToSelect.map{ (lineInfo: (line: String, active: Bool)) in
                LineInfo(line: lineInfo.line, active: false)
            }
            notifyResultHandler()
            collectionView?.reloadData()
        }
    }
}
