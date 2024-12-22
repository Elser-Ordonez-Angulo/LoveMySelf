import UIKit

class DiarioCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imagenImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imagenImageView.contentMode = .scaleAspectFill
        imagenImageView.clipsToBounds = true
    }
}
