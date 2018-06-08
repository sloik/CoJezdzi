
import ReSwift

struct MapState: StateType, Equatable {
    let currentTrams:  VehicleState
    let currentBusses: VehicleState
}

extension MapState {
    func currentTrams(_ ct:VehicleState) -> MapState {
        return MapState(currentTrams: ct, currentBusses: currentBusses)
    }
    
    func currentBusses(_ cb:VehicleState) -> MapState {
        return MapState(currentTrams: currentTrams, currentBusses: cb)
    }
}

extension MapState {
    var allCurrent: [WarsawVehicleDto] {
        return currentTrams.data + currentBusses.data
    }
    
    var allPrevious: [WarsawVehicleDto] {
        return currentTrams.previousData + currentBusses.previousData
    }
}
