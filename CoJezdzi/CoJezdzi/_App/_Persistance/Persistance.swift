
import ReSwift

class Persistance {
    init() {
        store.subscribe(self) {
            $0.select {
                $0.settingsState
            }
        }
    }
    
    func persist(state: SettingsState) {
        
    }
    
    func load(state: SettingsState) {
        
    }
}

// MARK: - ReSwift

extension Persistance: StoreSubscriber {
    func newState(state: SettingsState) {
        persist(state: state)
    }
}
