
import ReSwift

struct MapSceneState: StateType {
    var currentTrams:  VehicleState
    var currentBusses: VehicleState
}

extension MapSceneState {
    var allCurrent: [WarsawVehicleDto] {
        return currentTrams.data + currentBusses.data
    }
    
    var allPrevious: [WarsawVehicleDto] {
        return currentTrams.previousData + currentBusses.previousData
    }
}
