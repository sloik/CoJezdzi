import Foundation
import SBTUITestTunnel
import Overture

//        App.stubGetTrams(to: [WarsawVehicleDto])
//        // Current.dataPrivider.getTrams(completion: @escaping ResultBlock)
//        // do "completion" wchodzi przekazyna arejka "to" [WarsawVehicleDto]
//
//


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
