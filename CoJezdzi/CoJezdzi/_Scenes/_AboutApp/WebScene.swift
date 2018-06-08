
import SafariServices
import UIKit

class WebScene: UIViewController {

    @IBOutlet weak var spacer: UIView!

    lazy var webVC: SFSafariViewController = { [unowned self] in
        return  SFSafariViewController(url: URL(string:C.Networking.GoToURL.AboutApp)!)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildViewController(webVC)
        view.addSubview(webVC.view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webVC.view.frame = spacer.frame
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reduxStore.dispatch(RoutingSceneAppearsAction(scene: .aboutApp, viewController: self))
    }
}
