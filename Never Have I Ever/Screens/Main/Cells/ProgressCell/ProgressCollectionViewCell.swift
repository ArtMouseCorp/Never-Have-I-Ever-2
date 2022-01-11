import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var underImageView: UIView!
    
    // Image Views
    @IBOutlet weak var mainImageView: UIImageView!
    
    // MARK: - Awake functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        mainImageView.layer.cornerRadius = 8
    }
    
    func configureUI() {
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.contentView.clipsToBounds = false
        self.contentView.layer.masksToBounds = false
        
        roundCorners(radius: 12, corners: .allCorners)
        
        underImageView.roundCorners(radius: 8, corners: .allCorners)
        
        underImageView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        underImageView.layer.shadowOpacity = 0.2
        underImageView.layer.shadowRadius = 2
        underImageView.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
}

/*
 //           _._
 //        .-'   `
 //      __|__
 //     /     \
 //     |()_()|
 //     \{o o}/
 //      =\o/=
 //       ^ ^
 */
