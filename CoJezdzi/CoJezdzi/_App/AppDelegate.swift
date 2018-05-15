import UIKit

import Colours
import ReSwift

// Global <3 app state ;)
var store = Store<AppState>(reducer: appReducer,
                            state: nil,
                            middleware:[
//                                M.BS.dontGetTrams,
//                                M.logging
    ])

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var grouter: GamePlayAppRouter?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        UINavigationBar.appearance().tintColor = UIColor.eggplant()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        grouter = GamePlayAppRouter(window: window!) 
        
        window?.makeKeyAndVisible()

        return true
    }
}
