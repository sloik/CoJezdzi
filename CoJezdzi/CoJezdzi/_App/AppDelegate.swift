import UIKit

import Colours
import ReSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { fatalError("Did not create instance of UIWindow!") }

        UINavigationBar.appearance().tintColor = UIColor.eggplant()
        
        Current.router.takeOff(window)
        Current.persistance.load()
        
        window.makeKeyAndVisible()

        return true
    }
}
