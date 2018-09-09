
import ReSwift

class Persistence {
    enum Keys {
        static let persistance = "Persistance.SettingsState"
    }
    
    private(set) var persist = persist(state:)
    private(set) var load = loadSaved
    
    init(){}
    init(persist: @escaping ((SettingsState) -> Void), load: @escaping () -> SettingsState?) {
        self.persist = persist
        self.load = load
    }
}

// MARK: - Implementation Details

fileprivate func persist(state: SettingsState) {
    let data = try! JSONEncoder().encode(state)
    Current
        .userDefaults
        .set(data, forKey: Persistence.Keys.persistance)
}

func loadSaved() -> SettingsState? {
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
    guard let data = Current.userDefaults.data(forKey: Persistence.Keys.persistance) else { return nil }
    let state = try! JSONDecoder().decode(SettingsState.self, from: data)
    
    return state
}

// MARK: - ReSwift

extension Persistence: StoreSubscriber {
    func newState(state: SettingsState) {
        self.persist(state)
    }
}
