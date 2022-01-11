import UIKit

class DemoImagePopup: BasePopupViewController {

    // MARK: - @IBOutlets
    
    // MARK: - Variables
    
    var onPopupClose: (() -> ()) = {}
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupGestures()
    }
    
    override func setupGestures() {
        self.view.addTapGesture(target: self, action: #selector(closePopup))
    }
    
    // MARK: - Gesture actions
    
    @objc func closePopup() {
        self.view.removeFromSuperview()
        onPopupClose()
    }
    
    // MARK: - @IBActions
    
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
