import UIKit

class JokesTableViewCell: UITableViewCell {

    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var cellBackgroundView: UIView!
    
    // Labels
    @IBOutlet weak var articleTitleLabel: UILabel!
    
    // Image Views
    @IBOutlet weak var articleImageView: UIImageView!
    
    // MARK: - Variables
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    override func prepareForReuse() {
        articleImageView.image = UIImage()
    }
    
    // MARK: - Custom functions
    
    private func configureUI() {
        cellBackgroundView.roundCorners(radius: 16, corners: .allCorners)
        cellBackgroundView.clipsToBounds = true
        
        DispatchQueue.main.async {
            
            let gradient = CAGradientLayer()
            
            gradient.frame = self.articleImageView.frame
            
            gradient.colors = [
                UIColor.NHBlack.withAlphaComponent(0).cgColor,
                UIColor.NHBlack.withAlphaComponent(0.5).cgColor
            ]
            gradient.locations = [0.5, 1]
            
            self.articleImageView.layer.addSublayer(gradient)
        }
        
    }
    
    public func initialize(title: String, image: UIImage?) {
        articleTitleLabel.text = title
        articleImageView.image = image
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
