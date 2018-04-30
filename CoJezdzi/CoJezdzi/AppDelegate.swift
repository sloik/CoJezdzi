import UIKit

import Colours
import ReSwift

// Global <3 app state ;)
var appStore = Store<AppState>(reducer: appReducer, state: nil)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        UINavigationBar.appearance().tintColor = UIColor.eggplant()
        

        subscribeToStore()
        DispatchQueue.main.async {
            self.tempWipCodeForStuff()
        }
        
        return true
    }
}

extension AppDelegate: StoreSubscriber {
    func newState(state: AppState) {
        print(state)
    }
}

// MARK: - Temporary WiP code to test thing out

extension AppDelegate {

    func tempWipCodeForStuff() {
        appStore.dispatch(FetchTramsAction())
        appStore.dispatch(FetchBussesAction())
    }
    
    func subscribeToStore() {
        appStore.subscribe(self)
    }
}
