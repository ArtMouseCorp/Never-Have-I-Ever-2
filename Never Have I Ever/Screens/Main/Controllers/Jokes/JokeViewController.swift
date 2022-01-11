import UIKit

class JokeViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var jokeLabel: UILabel!
    
    // Image Views
    @IBOutlet weak var jokeImageView: UIImageView!
    
    // Constraints
    @IBOutlet weak var jokeLabelHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    
    var image: UIImage = UIImage()
    var jokeTitle = ""
    var joke = ""
    
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Custom functions
    
    override func configureUI() {
        
        jokeImageView.image = image
        titleLabel.text = jokeTitle
        jokeLabel.text = joke
        
        jokeImageView.roundCorners(radius: 16)
        DispatchQueue.main.async {
            let gradient = CAGradientLayer()
            gradient.frame = self.jokeImageView.frame
            gradient.colors = [
                UIColor.NHBlack.withAlphaComponent(0).cgColor,
                UIColor.NHBlack.withAlphaComponent(0.5).cgColor
            ]
            gradient.locations = [0.5, 1]
            self.jokeImageView.layer.addSublayer(gradient)
            
            self.jokeLabel.setLineHeight(lineHeight: 5)
            self.jokeLabel.sizeToFit()
            self.jokeLabelHeightConstraint.constant = self.jokeLabel.frame.height
        }
    }
        
    // MARK: - @IBActions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
