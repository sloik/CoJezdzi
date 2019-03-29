
import ReSwift

struct MapState: StateType, Equatable {
    var showTrafic = true
    var currentTrams:  VehicleState
    var currentBusses: VehicleState
}

extension MapState {
    var allCurrent: [WarsawVehicleDto] {
        return currentTrams.data + currentBusses.data
    }
    
    var allPrevious: [WarsawVehicleDto] {
        return currentTrams.previousData + currentBusses.previousData
    }
}
