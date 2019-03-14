import Foundation

@testable import AppFramework

extension Persistence {
    public static let mock = Persistence(
        persist: { (settingsState) in debugPrint(settingsState) },
           load: { return .mock })
}
