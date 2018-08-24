@testable import CoJezdzi

import XCTest
import Overture
import ReSwift

class AppMiddlewareTests: XCTestCase {

    func test_shoudldMakeAPICall_for_fetchVehiclesPosytionsAction() {
        // arange
        var didGetTrams  = false
        var didGetBusses = false
        
        Current = with(
            .mock, concat(
                set(\.dataProvider.getTrams,  { _ in didGetTrams  = true }),
                set(\.dataProvider.getBusses, { _ in didGetBusses = true })
            )
        )
        
        // act
        test(action: FetchVehiclesPosytionsAction(), middleware: M.Api)
        
        // assert
        XCTAssertTrue(didGetTrams,  "Did not call API method for getting trams!")
        XCTAssertTrue(didGetBusses, "Did not call API method for getting busses!")
    }

}
