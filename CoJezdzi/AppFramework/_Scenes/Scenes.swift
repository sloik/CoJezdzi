
import Rswift

struct Scenes {
    var map        : UIViewController { return R.storyboard.main.mapScene()!      }
    var settings   : UIViewController { return R.storyboard.main.settingsScene()! }
    var linesFilter: UIViewController { return R.storyboard.main.linesFilter()!   }
    var aboutApp   : UIViewController { return R.storyboard.main.aboutApp()!      }
}
