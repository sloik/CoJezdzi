
import ReSwift

class Persistence {
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

extension Persistence: StoreSubscriber {
    func newState(state: SettingsState) {
        persist(state: state)
    }
}
