
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
        
        SBTUITestTunnelServer.registerCustomCommandNamed("dupak") {
            injectedObject in


            let labelsData = injectedObject as! Data

            let labels = try! JSONDecoder()
                .decode(Constants.UI.Settings.MenuLabels.self,
                        from: labelsData)

            DispatchQueue.main.async {
                with(
                    &Current,
                    mut(\Environment.constants.ui.settings.menuLabels, labels)
                )

                Current
                    .reduxStore
                    .dispatch(RoutingAction(destination: .settings))
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
