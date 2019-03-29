import MapKit
import UIKit

struct Constants {
    struct Error {
        private(set) var Domain = "Co.Jezdzi.Error"
        
        struct Code {
            private(set) var NoBusData  = 42
            private(set) var NoTramData = 43
            
            private(set) var NetworkError = 44
            private(set) var WrongUrlResponseType = 45
            private(set) var NoDataOrServerError = 46
            
            struct UnableTo {
                private(set) var ParseJson = 101
                private(set) var MapJson = 102
            }
            private(set) var unableTo = UnableTo()
        }
        private(set) var code = Code()
    }
    private(set) var error = Error()
    
    struct Storyboard {
        struct CellReuseIds {
            private(set) var settingsSwitch      = "SettingsSwitchCell"
            private(set) var settingsGoingDeeper = "SettingsGoingDeeperCell"
            private(set) var settingsAboutApp    = "SettingsAboutAppCell"

            private(set) var filterLines         = "FilterLinesCell"
        }
        private(set) var cellreuseIds = CellReuseIds()
    }
    private(set) var storyboard = Storyboard()

    struct UI {
        struct Map {
            struct Dimention {
                private(set) var annotationSize = CGSize(width: 25, height: 25)
            }
            private(set) var dimention = Dimention()
        }
        private(set) var map = Map()

        struct Settings {
            struct MenuLabels: Codable { // at the moment only switch cells are connected to this ;)
                var filters    = "Filtry"
                var tramMarks  = "Poprzednie położenia"
                var aboutApp   = "O Aplikacji"
                var tramsOnly  = "Tylko 🚋"
                var bussesOnly = "Tylko 🚍"
            }
            var menuLabels = MenuLabels()
        }
        var settings = Settings()
    }
    var ui = UI()

    struct Coordinate {
        private(set) var center = CLLocationCoordinate2D(latitude: 52.2429341157752, longitude: 21.0083538438228) // Warsaw
        private(set) var spread: CLLocationDistance = 14000
        var warsawRegion: MKCoordinateRegion {
            return MKCoordinateRegion(center: center, latitudinalMeters: spread, longitudinalMeters: spread)
        }
    }
    private(set) var coordinate = Coordinate()
}
