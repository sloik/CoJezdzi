
import ReSwift

struct VehicleState: StateType {
    let data: [WarsawVehicleDto]
    let previousData: [WarsawVehicleDto]
}

extension VehicleState: Equatable {

    static func == (lhs: VehicleState, rhs: VehicleState) -> Bool {
        return
            lhs.data == rhs.data
                && lhs.previousData == rhs.previousData
    }
}
