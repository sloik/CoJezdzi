
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
        let cellReuseIds = Current.constants.storyboard.cellreuseIds
        let menuLabels = Current.constants.ui.settings.menuLabels
        
        let cells = [
            ViewModel(reuseID: cellReuseIds.settingsGoingDeeper, title: menuLabels.filters),
            ViewModel(reuseID: cellReuseIds.settingsSwitch,      title: menuLabels.bussesOnly),
            ViewModel(reuseID: cellReuseIds.settingsSwitch,      title: menuLabels.tramsOnly),
            ViewModel(reuseID: cellReuseIds.settingsSwitch,      title: menuLabels.tramMarks),
            ViewModel(reuseID: cellReuseIds.settingsAboutApp,    title: menuLabels.aboutApp)]
        
        return cells
    }
    
    var titleToState: [String: SettingsState.Filter] {
        let menuLabels = Current.constants.ui.settings.menuLabels
        
        return
            [menuLabels.tramMarks : latesState.switches.previousLocations,
             menuLabels.tramsOnly : latesState.switches.tramOnly,
             menuLabels.bussesOnly: latesState.switches.busOnly]
    }
    
    fileprivate var latesState: SettingsState! {
        didSet {
            refreshVisibleRows()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Current
            .reduxStore
            .subscribe(self) {
                $0.select {
                    $0.settingsState
                }
        }
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Current
            .reduxStore
            .dispatch(RoutingSceneAppearsAction(scene: .settings, viewController: self))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Current
            .reduxStore
            .unsubscribe(self)
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
        
        let cellReuseIds = Current.constants.storyboard.cellreuseIds
        let menuLabels   = Current.constants.ui.settings.menuLabels
        
        switch reuseID {
        case cellReuseIds.settingsGoingDeeper:
            switch viewModel.title {
            case menuLabels.filters:
                Current
                    .useCaseFactory
                    .navigateTo(.linesFilter)
                
            default:
                print("Unhandled action for cell with title \(viewModel.title)")
            }
            
        case cellReuseIds.settingsAboutApp:
            Current
                .useCaseFactory
                .navigateTo(.aboutApp)
            
        case cellReuseIds.settingsSwitch:
            let viewModel = cellOrdering[indexPath.row]
            let currentState = titleToState[viewModel.title]!
            
            Current
                .useCaseFactory
                .changeFilter(currentState.reversed)
            
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
        case Current.constants.storyboard.cellreuseIds.settingsSwitch:
            let switchCell = cell as! SwitchTableViewCell
            switchCell.delegate = self
            configureSwitchCell(cell: switchCell, atIndexPath: indexPath)
            
        case Current.constants.storyboard.cellreuseIds.settingsGoingDeeper:
            configureDeeper(cell: cell, with: viewModel)
            
        case Current.constants.storyboard.cellreuseIds.settingsAboutApp:
            configureAboutApplicationCell(cell: cell, viewModel: viewModel)
            
        default:
            fatalError("Unhandled Cell Reuse ID: \(viewModel.reuseID)")
        }
    }
    
    private func configureDeeper(cell: UITableViewCell, with viewModel: ViewModel) {
        
        switch viewModel.title {
        case Current.constants.ui.settings.menuLabels.filters:
            cell.textLabel?.text = "Wybierz Linie"
            cell.textLabel?.accessibilityIdentifier = "LineId"
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
        case Current.constants.ui.settings.menuLabels.tramMarks:
            Current
                .useCaseFactory
                .changeFilter(.previousLocation(on: isOn))
            
        case Current.constants.ui.settings.menuLabels.tramsOnly:
            Current
                .useCaseFactory
                .changeFilter(.tram(on: isOn))
            
        case Current.constants.ui.settings.menuLabels.bussesOnly:
            Current
                .useCaseFactory
                .changeFilter(.bus(on: isOn))
            
        default: print("\(#file) \(#line) -> No valid action for cell with title: \(String(describing: cell.switchNameLabel.text))")
        }
    }
}

// MARK: -
private typealias UserInteraction = SettingsVC
extension UserInteraction {
    @IBAction func uderDidTapCancelButton(_ sender: UIBarButtonItem) {
        
        // TODO: is this can be an action?
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
