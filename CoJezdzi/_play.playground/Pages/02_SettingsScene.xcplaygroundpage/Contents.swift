//:[ToC](ToC) | [Previous](@previous) | [Next](@next)

import UIKit
import PlaygroundSupport

import Overture

@testable import AppFramework
@testable import TestsHelpper

//: ### Example what you can do here
let about   = \Environment.constants.ui.settings.menuLabels.aboutApp
let marks   = \Environment.constants.ui.settings.menuLabels.tramMarks
let aOnly   = \Environment.constants.ui.settings.menuLabels.bussesOnly
let tOnly   = \Environment.constants.ui.settings.menuLabels.tramsOnly
let filters = \Environment.constants.ui.settings.menuLabels.filters

// new instance modified based on .mock template
Current = with(
    .mock,
    concat(
        set(about, "about"),
        set(marks, "marks"),
        set(aOnly, "A"),
        set(tOnly, "T"),
        set(filters, "F"))
)


// do this after some time
run {
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        // modify current env
        with(&Current,
             mut(\Environment.constants.ui.settings.menuLabels,
                 Constants.UI.Settings.MenuLabels()))

        // dispatch action
        let onTram = SettingsState.Filter.tram(on: true)
        let swithAction = SettingsSwitchAction(whitchSwitch: onTram)

        Current.reduxStore.dispatch(swithAction)
    }
}

//: # Display in LiveView

let (parent, _) = playgroundControllers(device: .phone5_5inch,
                                        orientation: .portrait,
                                        child: Current.scenes.settings)

PlaygroundPage.current.liveView = parent

//:[ToC](ToC) | [Previous](@previous) | [Next](@next)
