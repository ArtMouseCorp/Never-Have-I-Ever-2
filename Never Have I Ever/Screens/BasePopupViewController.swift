import UIKit

class BasePopupViewController: BaseViewController {
    
    // MARK: - Variables
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Custom functions
    
    override func configureUI() {
        super.configureUI()
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.bounds
        self.view.backgroundColor = .clear
        self.view.insertSubview(blurredEffectView, at: 0)
    }
    
    override func setupGestures() {
        super.setupGestures()
    }
    
    // MARK: - Gesture actions
    
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
