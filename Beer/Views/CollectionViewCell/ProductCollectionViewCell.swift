import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var nameProductLabel: UILabel!
    @IBOutlet weak var descuentoView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var discountLabel: UILabel!
    
    override func awakeFromNib() {
        self.containerView.layer.cornerRadius = 5
        self.containerView.layer.masksToBounds  = true
        self.layer.cornerRadius = 5
        self.descuentoView.layer.cornerRadius = 4
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 1.0
        self.clipsToBounds = false
        self.layer.masksToBounds = false
    }
    
    
}
