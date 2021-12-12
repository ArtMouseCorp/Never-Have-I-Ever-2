import UIKit

class QuitPopup: BasePopupViewController {

    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var backgroundView: UIView!
    
    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var quitButton: NHButton!
    @IBOutlet weak var cancelButton: NHButton!
    
    // MARK: - Variables
    
    var onQuitButtonPress: (() -> ())? = nil
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Custom functions
    
    override func localize() {
        super.localize()
        titleLabel.localize(with: "quit.title")
        subtitleLabel.localize(with: "quit.subtitle")
        quitButton.localize(with: "button.quit.quit")
        cancelButton.localize(with: "button.quit.cancel")
    }
    
    override func configureUI() {
        super.configureUI()
        
        backgroundView.roundCorners(radius: 15)
        
        quitButton.initialize(as: .filled)
        cancelButton.initialize(as: .outlined)
        
    }
    
    // MARK: - @IBActions
    
    @IBAction func quitButtonPressed(_ sender: Any) {
        onQuitButtonPress?() ?? ()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.view.removeFromSuperview()
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
