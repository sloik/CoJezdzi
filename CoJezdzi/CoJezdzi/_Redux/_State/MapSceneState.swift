
import ReSwift

struct MapSceneState: StateType {
    let currentTrams:  VehicleState
    let currentBusses: VehicleState
}

extension MapSceneState {
    func currentTrams(_ ct:VehicleState) -> MapSceneState {
        return MapSceneState(currentTrams: ct, currentBusses: currentBusses)
    }
    
    func currentBusses(_ cb:VehicleState) -> MapSceneState {
        return MapSceneState(currentTrams: currentTrams, currentBusses: cb)
    }
}

extension MapSceneState {
    var allCurrent: [WarsawVehicleDto] {
        return currentTrams.data + currentBusses.data
    }
    
    var allPrevious: [WarsawVehicleDto] {
        return currentTrams.previousData + currentBusses.previousData
    }
}
