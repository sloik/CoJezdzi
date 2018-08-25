
import UIKit

import Colours

public enum App {
    static public func takeOff(window: UIWindow) {
        UINavigationBar.appearance().tintColor = UIColor.eggplant()
        
        Current.router.takeOff(window)
        Current.persistance.load()
    }
}
