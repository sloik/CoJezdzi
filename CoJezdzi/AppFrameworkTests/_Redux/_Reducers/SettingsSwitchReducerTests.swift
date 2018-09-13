
import XCTest

@testable import AppFramework

class SettingsSwitchReducerTests: XCTestCase {

    func test_setingTramOnly_should_turnOnOnlyTramFilter() {
        // arrange
        let filterState = SettingsState.FilterState.mock

        let action = SettingsSwitchAction(whitchSwitch: .tram(on: true))

        // act
        let reduced = settingsSwitchReducer(action: action, state: filterState)

        // assert
        XCTAssertTrue(
            reduced.tramOnly.isOn,
            "Should have reduce state so the switch is on but it's off!"
        )

        XCTAssertFalse(
            reduced.busOnly.isOn,
            "For 'tram only' filter the 'bus only' should be off but its on!!"
        )
    }
}
