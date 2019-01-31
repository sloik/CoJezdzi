
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
        
        //:MARK ---------------------
        Current
            .useCaseFactory
            .loadPersistenState()
        
        SBTUITestTunnelServer.registerCustomCommandNamed("dupak") {
            injectedObject in
            // this block will be invoked from app.performCustomCommandNamed()
            
            guard let command = injectedObject as? String else { return nil }
            
            DispatchQueue.main.async {
                switch command {
                case "setCurrent":
                    Current = .mock
                    
                    Current
                        .reduxStore
                        .dispatch(RoutingAction(destination: .aboutApp ))
                default:
                    break
                }
            }
            
            return injectedObject
        }
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
