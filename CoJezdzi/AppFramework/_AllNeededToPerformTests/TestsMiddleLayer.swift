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
//        arg in
//        Current = .mock
//        return arg
        arg in

        let about   = \Environment.constants.ui.settings.menuLabels.aboutApp
        let marks   = \Environment.constants.ui.settings.menuLabels.tramMarks
        let aOnly   = \Environment.constants.ui.settings.menuLabels.bussesOnly
        let tOnly   = \Environment.constants.ui.settings.menuLabels.tramsOnly
        let filters = \Environment.constants.ui.settings.menuLabels.filters

        // new instance modified based on .mock template
        Current = with(.mock, concat(
            set(about, "ciastko"),
            set(marks, "pizza"),
            set(aOnly, "AWTOBUS"),
            set(tOnly, "TRAMŁAJNO"),
            set(filters, "FILTRYS")))

        return arg
    }
}

func stubGetTrams(_ to:[WarsawVehicleDto]) {
    
}
