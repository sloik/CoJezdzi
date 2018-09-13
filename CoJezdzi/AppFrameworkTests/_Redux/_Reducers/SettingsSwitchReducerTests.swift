
import XCTest

@testable import AppFramework

class SettingsSwitchReducerTests: XCTestCase {

    func test_setingTramOnly_should_turnOnOnlyTramFilter() {
        // arrange
        let filterState = SettingsState.FilterState.mock

        let action = SettingsSwitchAction(whitchSwitch: .tram(on: true))

        // act
        let r = settingsSwitchReducer(action: action, state: filterState)

        // assert
        XCTAssert(r.tramOnly.isOn, "Should have reduce state so the switch is on but it's off!")
        XCTAssert(r.tramOnly.ty, )
//        XCTAssert(r.busOnly.isOn == true, "For 'tram only' filter the 'bus only' should be off but its on!!")
    }
}

//                 set(\.tramOnly,.tram(on: on ? false : state.tramOnly.isOn))

