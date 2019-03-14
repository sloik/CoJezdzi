
import UIKit
import SBTUITestTunnel
import Overture

import Colours

public enum App {
    static public func takeOff(window: UIWindow) {
        UINavigationBar.appearance().tintColor = UIColor.eggplant()
        
        window.rootViewController = Current.router.rootVC()
        
        Current
            .useCaseFactory
            .loadPersistenState()
        
        //:MARK ---------------------
        Current
            .useCaseFactory
            .loadPersistenState()

        setMocks()
        
        //=---------============================================
        
        SBTUITestTunnelServer.registerCustomCommandNamed("print") {
            arg in
            print("------------------------------------------------------------------")
            return arg
        }
    }
        
        
        static public func startServer(){
            SBTUITestTunnelServer.takeOff()
        }
    }
