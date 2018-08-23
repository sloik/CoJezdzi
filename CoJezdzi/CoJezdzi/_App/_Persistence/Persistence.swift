
import ReSwift

class Persistence {
    enum Keys {
        static let persistance = "Persistance.SettingsState"
    }
    
    var persist = persist(state:)
    var load = loadSaved
    
    init(){}
    init(persist: @escaping ((SettingsState) -> Void), load: @escaping () -> ()) {
        self.persist = persist
        self.load = load
    }
}

// MARK: - Implementation Details

fileprivate func persist(state: SettingsState) {
    let data = try! JSONEncoder().encode(state)
    UserDefaults.standard.set(data, forKey: Persistence.Keys.persistance)
}

func loadSaved() {
    defer {
        Current
            .reduxStore
            .subscribe(Current.persistance) {
                $0.select {
                    $0.settingsState
                }
        }
    }
    
    // TODO: move to bg queue
    guard let data = Current.userDefaults.data(forKey: Persistence.Keys.persistance) else { return }
    let state = try! JSONDecoder().decode(SettingsState.self, from: data)
    
    Current
        .reduxStore
        .dispatch(SettingsDidRestoreAction(restoredState: state))
}

// MARK: - ReSwift

extension Persistence: StoreSubscriber {
    func newState(state: SettingsState) {
        self.persist(state)
    }
}
