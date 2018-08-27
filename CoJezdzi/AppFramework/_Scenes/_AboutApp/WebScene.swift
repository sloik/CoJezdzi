
import SafariServices
import UIKit

class WebScene: UIViewController {

    @IBOutlet weak var spacer: UIView!

    lazy var webVC: SFSafariViewController = { [unowned self] in
        return  SFSafariViewController(url: URL(string:Constants.Networking.GoToURL.AboutApp)!)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(webVC)
        view.addSubview(webVC.view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webVC.view.frame = spacer.frame
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Current
            .reduxStore
            .dispatch(RoutingSceneAppearsAction(scene: .aboutApp, viewController: self))
    }
}
