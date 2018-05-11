
import SafariServices
import UIKit

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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webVC.view.frame = view.frame
    }
}
