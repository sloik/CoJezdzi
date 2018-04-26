import UIKit

import ReSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var appStore = Store<AppState>(reducer: appReducer, state: nil)

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
