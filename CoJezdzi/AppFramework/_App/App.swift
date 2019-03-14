
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
        
        Current
            .useCaseFactory
            .loadPersistenState()
    }
}

public extension App {
    static public func registerTunel() {
        #if DEBUG
        #else
        return
        #endif

        setMocks()

        dupakCommand()

        gotoSceneCommand()

        SBTUITestTunnelServer.registerCustomCommandNamed("print") {
            arg in
            print("------------------------------------------------------------------")
            return arg
        }
    }

    static public func startServer(){
        #if DEBUG
        #else
        return
        #endif
        SBTUITestTunnelServer.takeOff()
    }
}

func dupakCommand() {
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
}

func gotoSceneCommand() {
    SBTUITestTunnelServer
        .registerCustomCommandNamed("gotoSceneCommand") { injectedObject in

        let destination = injectedObject as! String
        let rd = RoutingDestination(rawValue: destination)!

        DispatchQueue.main.async {
            Current
                .reduxStore
                .dispatch(RoutingAction(destination: rd))
        }

        return injectedObject
    }
}

