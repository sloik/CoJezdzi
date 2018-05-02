import Colours
import MapKit
import UIKit

class TAnnotationView: MKAnnotationView {

    static let ReuseID = "TAnnotationViewReuseID"

    var lineLabel: UILabel?

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        lineLabel = label
        if lineLabel != nil { addSubview(lineLabel!) }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // update corner radius
        let smalerDimension = min(frame.size.height, frame.size.width)
        self.layer.cornerRadius = smalerDimension / 2.0

        // update label frame
        let insetFactor: CGFloat = 8.0
        lineLabel?.bounds.size = CGSize(width: bounds.size.width - insetFactor,
                                      height: bounds.size.height - insetFactor)
        lineLabel?.center = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
    }
}

extension TAnnotationView {
    var label: UILabel {
        let l = UILabel.init(frame: CGRect.zero)
        l.minimumScaleFactor = 0.1
        l.textAlignment = .center
        l.adjustsFontSizeToFitWidth = true

        return l
    }
}

extension TAnnotationView {

    func configure(_ annotation: TAnnotation) {

        lineLabel?.text = annotation.lines
        
        configureColors(annotation)
    }

    fileprivate func configureColors(_ annotation: TAnnotation) {

        switch annotation.type {
        case .bus:
            backgroundColor      = UIColor.infoBlue()
            lineLabel?.textColor = UIColor.babyBlue()

        case .tram:
            backgroundColor      = UIColor.peach()
            lineLabel?.textColor = UIColor.chiliPowder()
            
        default:
            backgroundColor      = UIColor.warmGray()
            lineLabel?.textColor = UIColor.black
        }
    }
}
