
import Foundation

struct UseCaseFactory {
    private(set) var loadPersistenState: UseCase = LoadPersistetState()
}

// MARK: - Implementation Detail


fileprivate struct LoadPersistetState: UseCase { // This can be a free function... next step!
    func start() {
        guard let storedSettingsState = Current.persistance.load() else { return }
        
        Current
            .reduxStore
            .dispatch(SettingsDidRestoreAction(restoredState: storedSettingsState))
    }
}

