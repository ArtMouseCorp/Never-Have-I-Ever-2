import UIKit

class LevelPopup: BasePopupViewController {

    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var backgroundView: UIView!
    
    // Labels
    @IBOutlet weak var levelNameLabel: UILabel!
    @IBOutlet weak var levelDescriptionLevel: UILabel!
    
    // Buttons
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var selectButton: NHButton!
    
    // Image Views
    @IBOutlet weak var levelImageView: UIImageView!
    
    // MARK: - Variables
    
    var onSelectButtonPress: (() -> ()) = {}
    
    private var levelName: String = ""
    private var levelDescription: String = ""
    private var levelImage: UIImage?
    
    var isSelected: Bool = false
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Custom functions
    
    override func localize() {
        self.selectButton.localize(with: isSelected ? "button.home.deselect" : "button.home.select")
    }
    
    override func configureUI() {
        super.configureUI()
        
        levelNameLabel.text = levelName
        levelDescriptionLevel.text = levelDescription
        levelImageView.image = levelImage
        
        selectButton.initialize(as: .filled)
        
        backgroundView.roundCorners(radius: 15)
        backgroundView.setBorder(width: 1, color: isSelected ? .NHOrange : .NHDarkGray)
    }
    
    public func initialize(with level: Level) {
        self.levelName = level.name
        self.levelDescription = level.description
        self.levelImage = UIImage(named: level.image)
    }
    
    // MARK: - @IBActions
    
    @IBAction func selectButtonPressed(_ sender: Any) {
        self.onSelectButtonPress()
        self.view.removeFromSuperview()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
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
