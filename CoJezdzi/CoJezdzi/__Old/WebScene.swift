
import SafariServices
import UIKit

//import SnapKit

class WebScene: UIViewController {

    @IBOutlet weak var spacer: UIView!

    var goToURLString: String = "https://www.google.pl"

    lazy var webVC: SFSafariViewController = { [unowned self] in
        return  SFSafariViewController(url: URL(string:self.goToURLString)!)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildViewController(webVC)
        view.addSubview(webVC.view)

//        webVC.view.snp.makeConstraints { (make) in
//            make.edges.equalTo(spacer)
//        }
    }
}
