
import UIKit
import SBTUITestTunnel

import Colours

public enum App {
    static public func takeOff(window: UIWindow) {
        UINavigationBar.appearance().tintColor = UIColor.eggplant()
        
        window.rootViewController = Current.router.rootVC()
        
        Current
            .useCaseFactory
            .loadPersistenState()
    }
    
    static public func startServer(){
        SBTUITestTunnelServer.takeOff()
    }
    
}
