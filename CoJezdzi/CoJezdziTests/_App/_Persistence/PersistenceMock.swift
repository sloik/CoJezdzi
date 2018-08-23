import Foundation

@testable import CoJezdzi

extension Persistence {
    static let mock = Persistence(
        persist: { (settingsState) in debugPrint(settingsState) },
           load: {debugPrint("Loading state from persistance!")})
}
