
import UIKit

import Colours

public enum App {
    static public func takeOff(window: UIWindow) {
        UINavigationBar.appearance().tintColor = UIColor.eggplant()
        
        window.rootViewController = Current.router.rootVC()
        
        Current
            .useCaseFactory
            .loadPersistenState
            .start()        
    }
}
