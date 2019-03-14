import Foundation
import SBTUITestTunnel
import Overture

//        App.stubGetTrams(to: [WarsawVehicleDto])
//        // Current.dataPrivider.getTrams(completion: @escaping ResultBlock)
//        // do "completion" wchodzi przekazyna arejka "to" [WarsawVehicleDto]
//
//

func getRoutes(){
    let routingActions = RoutingDestination.allCases.randomElement()

    DispatchQueue.main.async {

        Current
        .reduxStore
            .dispatch(RoutingAction(destination: routingActions!))
    }



}

func getRandomRoute(){

    SBTUITestTunnelServer.registerCustomCommandNamed("getRandomRoute") {

        injectedObject in

        DispatchQueue.main.async {
            getRoutes()
        }
        return injectedObject
    }
}


func setMocks(){
    SBTUITestTunnelServer.registerCustomCommandNamed("setMocks") {
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

func stubGetTrams(_ to:[WarsawVehicleDto]) {
    
}
