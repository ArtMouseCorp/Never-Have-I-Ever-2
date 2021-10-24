import UIKit

class SubscriptionViewConrtoller: BaseViewController {
    
    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var subscribeButtonView: UIView!
    
    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var subscribeButtonLabel: UILabel!
    @IBOutlet var reasonLabels: [UILabel]!
    @IBOutlet weak var cancelInfoLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    
    // Activity Indicators
    @IBOutlet weak var priceActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reasonsActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var subscribeActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables
    
    var product: StoreManager.Product?
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SubscriptionConfig.get {
            DispatchQueue.main.async {
                self.loadSubscriptionInfo()
                self.getProducts()
            }
        }
    }
    
    // MARK: - Custom functions
    
    override func localize() {
        restoreButton.localize(with: "button.subscription.restore")
        cancelInfoLabel.localize(with: "subscription.cancelInfo")
        termsButton.localize(with: "button.subsctiption.terms")
        privacyButton.localize(with: "button.subscription.privacy")
    }
    
    override func configureUI() {
        super.configureUI()
        
        configureButton()
        
        closeButton.hide(!State.shared.subscriptionConfig.showCloseButton)
        
        titleLabel.hide()
        priceLabel.hide()
        reasonLabels.forEach { $0.hide() }
        subscribeButtonLabel.hide()
        restoreButton.isEnabled = false
    }
    
    override func setupGestures() {
        super.setupGestures()
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
        
    }
    
    private func getProducts() {
        
        guard isConnectedToNetwork() else {
            self.showNetworkConnectionAlert() {
                self.dismiss(animated: true)
            }
            return
        }
        
        
        let productId = State.shared.subscriptionConfig.product.productId
        
        
        StoreManager.getProducts(for: [productId]) { products in
            
            guard let product = products.first else {
                self.dismiss(animated: true)
                return
            }
            
            self.product = product
            
            DispatchQueue.main.async {
                self.loadSubscriptionPrice()
            }
            
        }
        
    }
    
    private func loadSubscriptionInfo() {
        
        self.titleLabel.text = State.shared.subscriptionConfig.title
        
        self.reasonLabels[0].text = State.shared.subscriptionConfig.reasons[0]
        self.reasonLabels[1].text = State.shared.subscriptionConfig.reasons[1]
        self.reasonLabels[2].text = State.shared.subscriptionConfig.reasons[2]
        
        self.reasonsActivityIndicator.stopAnimating()
        
        self.titleLabel.show()
        self.reasonLabels.forEach { $0.show() }
        
    }
    
    private func loadSubscriptionPrice() {
        
        guard let product = product else { return }
        
        if let trialPeriod = product.trialPeriod {
            
            self.priceLabel.text = State.shared.subscriptionConfig.product.title
                .replacingOccurrences(of: "%trial_period%", with: trialPeriod)
                .replacingOccurrences(of: "%subscription_price%", with: product.price)
                .replacingOccurrences(of: "%subscription_period%", with: product.subscriptionPeriod)
            
        } else {
            
            self.priceLabel.text = State.shared.subscriptionConfig.product.title
                .replacingOccurrences(of: "%subscription_price%", with: product.price)
                .replacingOccurrences(of: "%subscription_period%", with: product.subscriptionPeriod)
        }
        
        
        self.subscribeButtonLabel.text = State.shared.subscriptionConfig.buttonTitle
        
        self.priceActivityIndicator.stopAnimating()
        self.subscribeActivityIndicator.stopAnimating()
        
        self.priceLabel.show()
        self.subscribeButtonLabel.show()
        self.restoreButton.isEnabled = true
        
        self.subscribeButtonView.addTapGesture(target: self, action: #selector(subscribeButtonViewTapped))
        
    }
    
    // MARK: - Gesture actions
    
    @objc private func subscribeButtonViewTapped(_ sender: Any) {
        
        self.subscribeButtonView.flash()
        
        guard let product = product else {
            self.dismiss(animated: true)
            return
        }
        
        guard isConnectedToNetwork() else {
            self.showNetworkConnectionAlert()
            return
        }
        
        StoreManager.purchase(product) {
            self.dismiss(animated: true)
        }
        
    }
    
    // MARK: - @IBActions
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func restoreButtonPressed(_ sender: Any) {
        
        guard isConnectedToNetwork() else {
            self.showNetworkConnectionAlert()
            return
        }
        
        StoreManager.restore {
            self.dismiss(animated: true)
        }
        
    }
    
    @IBAction func termsButtonPressed(_ sender: Any) {
        guard let url = URL(string: Config.TERMS_URL) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func privacyButtonPressed(_ sender: Any) {
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
