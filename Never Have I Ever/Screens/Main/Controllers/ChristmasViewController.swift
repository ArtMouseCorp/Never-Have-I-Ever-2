import UIKit

class ChristmasViewController: UIViewController {

    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var subscribeButtonView: UIView!
    @IBOutlet weak var timerBackgroundView: UIView!
    @IBOutlet var dotViews: [UIView]!
    
    // Labels
    @IBOutlet weak var timerLabel: UILabel!
    
    // Buttons
    // Image Views
    // ...

    // MARK: - Variables
    
    var timer = Timer()
    var minutes = 9
    var seconds = 59
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI()
        setupGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timerStart()
    }
    
    // MARK: - Custom functions
    
    private func configureUI() {
        configureButton()
        configureDots()
    }
    
    private func configureButton() {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
            CGColor(red: 0.961, green: 0.592, blue: 0.196, alpha: 1),
            CGColor(red: 1, green: 0.42, blue: 0, alpha: 1)
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        gradientLayer.frame = subscribeButtonView.bounds
        self.subscribeButtonView.layer.insertSublayer(gradientLayer, at: 0)
        self.subscribeButtonView.roundCorners(radius: 14)
        self.subscribeButtonView.clipsToBounds = true
        
        gradientLayer.frame = timerBackgroundView.bounds
        self.timerBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
        self.timerBackgroundView.roundCorners(radius: 14)
        self.timerBackgroundView.clipsToBounds = true
    }
    
    private func configureDots() {
        for view in dotViews {
            view.capsuleCorners()
        }
    }
    
    private func setupGestures() {
        subscribeButtonView.addTapGesture(target: self, action: #selector(subscribeButtonTapped))
    }
    
    private func timerStart() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func timerAction() {
        if seconds == 0 {
            if minutes == 0 {
                timer.invalidate()
            }
            else {
                minutes -= 1
                seconds = 59
            }
        } else {
            seconds -= 1
        }
        timerLabel.text = "\(minutes) min \(seconds) sec"
    }
    
    // MARK: - Gesture actions
    
    @objc func subscribeButtonTapped() {
        self.subscribeButtonView.flash()
        print("Subscribe button tapped")
    }
    
    // MARK: - @IBActions
    
    @IBAction func termsOfUseButtonPressed(_ sender: Any) {
        guard let url = URL(string: Config.TERMS_URL) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func restorePurchasesButtonPressed(_ sender: Any) {
        guard isConnectedToNetwork() else {
            self.showNetworkConnectionAlert()
            return
        }
        
        StoreManager.restore {
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func policyButtonPressed(_ sender: Any) {
        guard let url = URL(string: Config.PRIVACY_URL) else { return }
        UIApplication.shared.open(url)
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
