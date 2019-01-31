import Foundation
import SBTUITestTunnel

//        App.stubGetTrams(to: [WarsawVehicleDto])
//        // Current.dataPrivider.getTrams(completion: @escaping ResultBlock)
//        // do "completion" wchodzi przekazyna arejka "to" [WarsawVehicleDto]
//
//


func setMocks(){
    SBTUITestTunnelServer.registerCustomCommandNamed("setMocks") {
        arg in
        Current = .mock
        return arg
    }
}

func stubGetTrams(_ to:[WarsawVehicleDto]) {
    
}
