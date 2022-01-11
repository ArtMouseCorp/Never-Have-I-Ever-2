import UIKit

class ImagePopup: BasePopupViewController {

    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var mainView: UIView!
    
    // Image Views
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Variables
    
    var mainImage: UIImage?
    var onPopupClose: (()->()) = {}
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageView.image = mainImage ?? UIImage(named: "image")
    }
    
    // MARK: - Custom functions
    
    override func configureUI() {
        mainView.layer.cornerRadius = 28
        imageView.layer.cornerRadius = 28
    }
    
    // MARK: - @IBActions
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        onPopupClose()
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
