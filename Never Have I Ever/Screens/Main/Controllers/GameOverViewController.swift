import UIKit
import StoreKit

class GameOverViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var repeatButton: NHButton!
    @IBOutlet weak var rateButton: NHButton!
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Custom functions
    
    override func localize() {
        titleLabel.localize(with: "gameOver.title")
        repeatButton.localize(with: "button.gameOver.repeat")
        rateButton.localize(with: "button.gameOver.rate")
    }
    
    override func configureUI() {
        super.configureUI()
        
        repeatButton.initialize(as: .filled)
        rateButton.initialize(as: .outlined)
    }
    
    // MARK: - @IBActions
    
    @IBAction func repeatButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func rateButtonPressed(_ sender: Any) {
        SKStoreReviewController.requestReview()
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
