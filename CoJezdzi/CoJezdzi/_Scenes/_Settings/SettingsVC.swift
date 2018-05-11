
import UIKit

import ReSwift

private struct ViewModel {
    let reuseID: String
    let title  : String

    init(reuseID: String, title: String) {
        self.reuseID = reuseID
        self.title   = title
    }
}

class SettingsVC: UITableViewController {

    fileprivate var cellOrdering: [ViewModel]  {

        let cells = [
            ViewModel(reuseID: C.Storyboard.CellReuseId.SettingsGoingDeeperCell, title: C.UI.Settings.MenuLabels.Filters),
            ViewModel(reuseID: C.Storyboard.CellReuseId.SettingsSwitchCell,      title: C.UI.Settings.MenuLabels.BussesOnly),
            ViewModel(reuseID: C.Storyboard.CellReuseId.SettingsSwitchCell,      title: C.UI.Settings.MenuLabels.TramsOnly),
            ViewModel(reuseID: C.Storyboard.CellReuseId.SettingsSwitchCell,      title: C.UI.Settings.MenuLabels.TramMarks),
            ViewModel(reuseID: C.Storyboard.CellReuseId.SettingsAboutAppCell,    title: C.UI.Settings.MenuLabels.AboutApp)]

        return cells
    }
    
    var titleToState: [String: SettingsState.Filter] {
        return
            [C.UI.Settings.MenuLabels.TramMarks : latesState.switches.previousLocations,
             C.UI.Settings.MenuLabels.TramsOnly : latesState.switches.tramOnly,
             C.UI.Settings.MenuLabels.BussesOnly: latesState.switches.busOnly]
    }
    
    fileprivate var latesState: SettingsState! {
        didSet {
            refreshVisibleRows()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        store.subscribe(self) {
            $0.select {
                $0.settingsState
            }
        }
        
        store.dispatch(RoutingAction(destination: .settings))

        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        store.unsubscribe(self)
    }
}

// MARK: - UITableViewDelegate
extension SettingsVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        actionForCell(at: indexPath)
    }
    
    func refresSwitches() {
        tableView.visibleCells
            .compactMap { return $0 as? SwitchTableViewCell }
            .forEach {
                if let title = $0.switchNameLabel.text, let state = titleToState[title] {
                    $0.cellSwitch.setOn(state.isOn, animated: true)
                }
        }
    }
    
    fileprivate func actionForCell(at indexPath: IndexPath) {
        let viewModel = cellOrdering[indexPath.row]
        let reuseID = viewModel.reuseID

        switch reuseID {
        case C.Storyboard.CellReuseId.SettingsGoingDeeperCell:
            switch viewModel.title {
            case C.UI.Settings.MenuLabels.Filters:
                performSegue(withIdentifier: R.segue.settingsVC.settingsFilterLines.identifier , sender: nil)
                
            default:
                print("Unhandled action for cell with title \(viewModel.title)")
            }
            
        case C.Storyboard.CellReuseId.SettingsButtonCell:
            break
            
        case C.Storyboard.CellReuseId.SettingsAboutAppCell:
             performSegue(withIdentifier: R.segue.settingsVC.aboutApplication.identifier, sender: nil)
            
        case C.Storyboard.CellReuseId.SettingsSwitchCell:
            
            let viewModel = cellOrdering[indexPath.row]
            let currentState = titleToState[viewModel.title]!
            
            store.dispatch(SettingsSwitchAction(whitchSwitch: currentState.reversed))
 
        default:
            return
        }
    }
}

// MARK: -
private typealias CellConfiguration = SettingsVC
extension CellConfiguration {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellOrdering.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCell(at: indexPath)
    }
    
    // MARK: Helpers
    func configureCell(at indexPath: IndexPath) -> UITableViewCell {
        let viewModel = cellOrdering[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.reuseID, for: indexPath)
        
        configure(cell: cell, at: indexPath)
        
        return cell
    }
    
    func configure(cell: UITableViewCell, at indexPath: IndexPath) {
        let viewModel = cellOrdering[indexPath.row]
        
        switch viewModel.reuseID {
        case C.Storyboard.CellReuseId.SettingsSwitchCell:
            let switchCell = cell as! SwitchTableViewCell
            switchCell.delegate = self
            configureSwitchCell(cell: switchCell, atIndexPath: indexPath)
            
        case C.Storyboard.CellReuseId.SettingsGoingDeeperCell:
            configureDeeper(cell: cell, with: viewModel)
            
        case C.Storyboard.CellReuseId.SettingsButtonCell:
            configureButton(cell: (cell as! ButtonTableViewCell), viewModel: viewModel)
            
        case C.Storyboard.CellReuseId.SettingsAboutAppCell:
            configureAboutApplicationCell(cell: cell, viewModel: viewModel)
            
        default:
            fatalError("Unhandled Cell Reuse ID: \(viewModel.reuseID)")
        }
    }
    
    private func configureDeeper(cell: UITableViewCell, with viewModel: ViewModel) {
        
        switch viewModel.title {
        case C.UI.Settings.MenuLabels.Filters:
            cell.textLabel?.text = "Wybierz Linie"
            cell.detailTextLabel?.text = "Wszystkie"
            
            if latesState.selectedLines.lines.isEmpty == false {
                cell.detailTextLabel?.text =
                    latesState.selectedLines.lines
                        .map { $0.name }
                        .sorted { Int($0) < Int($1) }
                        .joined(separator: ", ")
            }
            
        default:
            print("Unhandled title for deeper cell with title \(viewModel.title)")
        }
    }
    
    private func configureButton(cell: ButtonTableViewCell, viewModel: ViewModel) {
        cell.button.setTitle(viewModel.title, for: UIControlState())
    }
    
    private func configureAboutApplicationCell(cell: UITableViewCell, viewModel: ViewModel) {
        cell.textLabel?.text = viewModel.title
    }
    
    func configureSwitchCell(cell: SwitchTableViewCell, atIndexPath indexPath: IndexPath) {
        
        guard indexPath.row < cellOrdering.count else { return } // this is a error, some kind of log?
        
        let viewModel = cellOrdering[indexPath.row]
        
        cell.switchNameLabel.text = viewModel.title
        cell.updateSwitchState(titleToState[viewModel.title]!.isOn)
    }
    
    func refreshVisibleRows() {
        guard let visibleIndexes = tableView.indexPathsForVisibleRows else { return }

        visibleIndexes.forEach { configure(cell: tableView.cellForRow(at: $0)!, at: $0) }
    }
}

//MARK: -
extension SettingsVC: SwitchCellInteraction {
    func cellSwichValueDidChange(cell: SwitchTableViewCell, isOn: Bool) {
        guard let cellTitle = cell.switchNameLabel.text else { return }

        switch cellTitle {
        case C.UI.Settings.MenuLabels.TramMarks:
            store.dispatch(SettingsSwitchAction(whitchSwitch: .previousLocation(on: isOn)))

        case C.UI.Settings.MenuLabels.TramsOnly:
            store.dispatch(SettingsSwitchAction(whitchSwitch: .tram(on: isOn)))
            
        case C.UI.Settings.MenuLabels.BussesOnly:
            store.dispatch(SettingsSwitchAction(whitchSwitch: .bus(on: isOn)))

        default: print("\(#file) \(#line) -> No valid action for cell with title: \(String(describing: cell.switchNameLabel.text))")
        }
    }
}

// MARK: -
private typealias UserInteraction = SettingsVC
extension UserInteraction {
    @IBAction func uderDidTapCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion:nil)
    }
}

// MARK: ReSwift

extension SettingsVC: StoreSubscriber {
    func newState(state: SettingsState) {
        latesState = state
    }
}

// MARK: -
