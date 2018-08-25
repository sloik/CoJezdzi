import Foundation

@testable import AppFramework

extension Persistence {
    static let mock = Persistence(
        persist: { (settingsState) in debugPrint(settingsState) },
           load: {debugPrint("Loading state from persistance!")})
}
