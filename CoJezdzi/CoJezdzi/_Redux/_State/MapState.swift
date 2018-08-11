
import ReSwift

struct MapState: StateType, Equatable {
    private(set) var currentTrams:  VehicleState
    private(set) var currentBusses: VehicleState
}

extension MapState {
    var allCurrent: [WarsawVehicleDto] {
        return currentTrams.data + currentBusses.data
    }
    
    var allPrevious: [WarsawVehicleDto] {
        return currentTrams.previousData + currentBusses.previousData
    }
}
