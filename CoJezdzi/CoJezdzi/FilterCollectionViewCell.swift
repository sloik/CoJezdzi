import UIKit

class FilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!

    var active: Bool {
        didSet {
            updateBackgroundColor()
        }
    }

    var labelText: String? {
        set {
            label.text = newValue
        }

        get {
            return label.text
        }
    }

    required init?(coder aDecoder: NSCoder) {
        active = false
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        label.textColor = UIColor.grape()
        layer.cornerRadius = 5;
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.palePurple().cgColor
    }

    fileprivate func updateBackgroundColor() {

        if active {
            contentView.backgroundColor = UIColor.palePurple().withAlphaComponent(0.25)
        }
        else {
            contentView.backgroundColor = UIColor.white
        }
    }
}
