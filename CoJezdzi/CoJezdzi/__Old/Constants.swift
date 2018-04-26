import MapKit
import UIKit

struct C {
    
    struct API {
        static let FakeAPI = "YOUR_WARSAW_API_API_KEY"
    }
    
    struct Error {
        static let Domain = "Co.Jezdzi.Error"
        
        struct Code {
            static let NoBusData  = 42
            static let NoTramData = 43
            
            static let NetworkError = 44
            static let WrongUrlResponseType = 45
            static let NoDataOrServerError = 46
            
            struct UnableTo {
                static let ParseJson = 101
                static let MapJson = 102
            }
        }
    }
    struct Storyboard {
        struct ViewControllerID {
            static let Map      = "MapScene"
            static let Settings = "SettingsScene"
        }

        struct CellReuseId {
            static let SettingsSwitchCell      = "SettingsSwitchCell"
            static let SettingsGoingDeeperCell = "SettingsGoingDeeperCell"
            static let SettingsButtonCell      = "SettingsButtonCell"
            static let SettingsAboutAppCell    = "SettingsAboutAppCell"

            static let FilterLinesCell         = "FilterLinesCell"
        }

        struct SegueID {
            static let SettingsFilterLines = "SettingsFilterLines"
            static let AboutApplication    = "AboutApplication"
            static let ShowSettings        = "ShowSettings"
            static let ShowWebAPIForm      = "ShowWebAPIForm"
        }
    }

    struct UI {
        struct PageMenu {
            static let Height: CGFloat = 60.0
        }

        struct Map {
            struct Dimonsion {
                static let AnnotationViewSize = CGSize(width: 25, height: 25)
            }
        }

        struct Settings {
            struct MenuLabels { // at the moment only switch cells are connected to this ;)
                static let City       = "Wybierz miasto"
                static let Filters    = "Filtry"
                static let TramMarks  = "Poprzednie położenia"
                static let AboutApp   = "O Aplikacji"
                static let TramsOnly  = "Tylko 🚋"
                static let BussesOnly = "Tylko 🚍"
            }
        }
    }

    struct Networking {
        static let URLParamSeperator = "&"

        struct GoToURL {
            static let AboutApp      = "https://avantapp.wordpress.com/co-jezdzi/"
            static let APIUMWarszawa = "https://api.um.warszawa.pl"
        }

        struct HTTPMethod {
            static let GET  = "GET"
            static let POST = "POST"
        }
    }

    struct Coordinate {
        static let WarsawCenter = CLLocationCoordinate2D(latitude: 52.2429341157752, longitude: 21.0083538438228)
        static let DefaultSpreadDistance: CLLocationDistance = 14000
        static let WarsawRegion = MKCoordinateRegionMakeWithDistance(WarsawCenter, DefaultSpreadDistance, DefaultSpreadDistance)
    }
}
