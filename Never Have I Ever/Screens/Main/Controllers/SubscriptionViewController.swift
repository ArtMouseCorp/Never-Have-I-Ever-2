import UIKit

class SubscriptionViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var trialSubscribtionView: UIView!
    @IBOutlet weak var trialSubscribtionOuterCircleView: UIView!
    @IBOutlet weak var trialSubscribtionInnerCircleView: UIView!
    
    @IBOutlet weak var notTrialSubscribtionView: UIView!
    @IBOutlet weak var notTrialSubscribtionOuterCircleView: UIView!
    @IBOutlet weak var notTrialSubscribtionInnerCircleView: UIView!
    
    @IBOutlet weak var saveAmountView: UIView!
    @IBOutlet weak var subscribeButtonView: UIView!
    
    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var trialPeriodLabel: UILabel!
    @IBOutlet var reasonLabels: [UILabel]!
    @IBOutlet weak var trialSubscribtionLabel: UILabel!
    @IBOutlet weak var notTrialSubscribtionLabel: UILabel!
    @IBOutlet weak var saveAmountLabel: UILabel!
    @IBOutlet weak var subscribeButtonLabel: UILabel!
    
    
    // Buttons
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    
    // Activity Indicators
    @IBOutlet weak var trialActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reasonsActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var trialSubscriptionActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var notTrialSubscriptionActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var subscribeActivityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Variables
    
    var trialProduct: StoreManager.Product?
    var notTrialProduct: StoreManager.Product?
    
    var selectedProduct: StoreManager.Product?
    
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
        termsButton.localize(with: "button.subsctiption.terms")
        privacyButton.localize(with: "button.subscription.privacy")
    }
    
    override func configureUI() {
        super.configureUI()
        
        configureButton()
        
        trialSubscribtionView.roundCorners(radius: 15)
        
        notTrialSubscribtionView.roundCorners(radius: 15)
        
        trialSubscribtionOuterCircleView.capsuleCorners()
        trialSubscribtionOuterCircleView.setBorder(width: 1, color: .NHWhite)
        trialSubscribtionOuterCircleView.backgroundColor = .clear
        
        trialSubscribtionInnerCircleView.capsuleCorners()
        
        notTrialSubscribtionOuterCircleView.capsuleCorners()
        notTrialSubscribtionOuterCircleView.setBorder(width: 1, color: .NHWhite)
        notTrialSubscribtionOuterCircleView.backgroundColor = .clear
        
        notTrialSubscribtionInnerCircleView.capsuleCorners()
        
        closeButton.hide(!State.shared.subscriptionConfig.showCloseButton)
        
        saveAmountView.roundCorners(radius: 5)
        
        titleLabel.hide()
        trialPeriodLabel.hide()
        reasonLabels.forEach { $0.hide() }
        
        saveAmountView.hide()
        
        trialSubscribtionOuterCircleView.hide()
        trialSubscribtionInnerCircleView.hide()
        notTrialSubscribtionOuterCircleView.hide()
        notTrialSubscribtionInnerCircleView.hide()
        
        trialSubscribtionLabel.hide()
        notTrialSubscribtionLabel.hide()
        
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
        
        
        let productIds = [
            State.shared.subscriptionConfig.trialProduct.productId,
            State.shared.subscriptionConfig.notTrialProduct.productId
        ]
        
        
        StoreManager.getProducts(for: productIds) { products in
            
            guard products.count == 2 else {
                self.dismiss(animated: true)
                return
            }
            
            self.trialProduct = products[0]
            self.notTrialProduct = products[1]
            self.selectedProduct = self.trialProduct
            
            DispatchQueue.main.async {
                self.loadSubscriptionPrice()
            }
            
        }
        
    }
    
    private func loadSubscriptionInfo() {
        
        self.titleLabel.text = State.shared.subscriptionConfig.title
        
        self.reasonLabels[0].text = State.shared.subscriptionConfig.reasons[0]
        self.reasonLabels[0].colorText(from: "<h>", to: "</h>", color: .NHOrange)
        self.reasonLabels[1].text = State.shared.subscriptionConfig.reasons[1]
        self.reasonLabels[1].colorText(from: "<h>", to: "</h>", color: .NHOrange)
        self.reasonLabels[2].text = State.shared.subscriptionConfig.reasons[2]
        self.reasonLabels[2].colorText(from: "<h>", to: "</h>", color: .NHOrange)
        
        self.reasonsActivityIndicator.stopAnimating()
        
        self.titleLabel.show()
        self.reasonLabels.forEach { $0.show() }
        
    }
    
    private func loadSubscriptionPrice() {
        
        guard
            let trialProduct = trialProduct,
            let notTrialProduct = notTrialProduct
        else {
            return
        }
        
        if let trialPeriod = trialProduct.trialPeriod {
            
            self.trialPeriodLabel.text = State.shared.subscriptionConfig.trialPeriodTitle
                .replacingOccurrences(of: "%trial_period%", with: trialPeriod)
            
            self.trialSubscribtionLabel.text = State.shared.subscriptionConfig.trialProduct.title
                .replacingOccurrences(of: "%trial_period%", with: trialPeriod)
                .replacingOccurrences(of: "%subscription_price%", with: trialProduct.price)
                .replacingOccurrences(of: "%subscription_period%", with: trialProduct.subscriptionPeriod)
            
        } else {
            
            self.trialPeriodLabel.text = ""
            
            self.trialSubscribtionLabel.text = State.shared.subscriptionConfig.trialProduct.title
                .replacingOccurrences(of: "%subscription_price%", with: trialProduct.price)
                .replacingOccurrences(of: "%subscription_period%", with: trialProduct.subscriptionPeriod)
        }
        
        if let trialPeriod = notTrialProduct.trialPeriod {
            
            self.notTrialSubscribtionLabel.text = State.shared.subscriptionConfig.notTrialProduct.title
                .replacingOccurrences(of: "%trial_period%", with: trialPeriod)
                .replacingOccurrences(of: "%subscription_price%", with: notTrialProduct.price)
                .replacingOccurrences(of: "%subscription_period%", with: notTrialProduct.subscriptionPeriod)
            
        } else {
            
            self.notTrialSubscribtionLabel.text = State.shared.subscriptionConfig.notTrialProduct.title
                .replacingOccurrences(of: "%subscription_price%", with: notTrialProduct.price)
                .replacingOccurrences(of: "%subscription_period%", with: notTrialProduct.subscriptionPeriod)
            
        }
        
        if let saveLabel = State.shared.subscriptionConfig.trialProduct.saveLabel {
            self.saveAmountLabel.text = saveLabel
            self.saveAmountView.show()
        }
        
        self.subscribeButtonLabel.text = State.shared.subscriptionConfig.buttonTitle
        
        self.trialActivityIndicator.stopAnimating()
        self.trialSubscriptionActivityIndicator.stopAnimating()
        self.notTrialSubscriptionActivityIndicator.stopAnimating()
        self.subscribeActivityIndicator.stopAnimating()
        
        self.trialSubscribtionView.setBorder(width: 1, color: .NHOrange)
        
        self.trialSubscribtionOuterCircleView.show()
        self.trialSubscribtionInnerCircleView.show()
        self.notTrialSubscribtionOuterCircleView.show()
        
        self.trialSubscribtionLabel.colorText(from: "<h>", to: "</h>", color: .NHOrange)
        self.trialSubscribtionLabel.show()
        
        self.notTrialSubscribtionLabel.colorText(from: "<h>", to: "</h>", color: .NHOrange)
        self.notTrialSubscribtionLabel.show()
        
        self.trialPeriodLabel.colorText(from: "<h>", to: "</h>", color: .NHOrange)
        self.trialPeriodLabel.uppercase()
        self.trialPeriodLabel.show()
        self.subscribeButtonLabel.show()
        self.restoreButton.isEnabled = true
        
        self.subscribeButtonView.addTapGesture(target: self, action: #selector(subscribeButtonViewTapped))
        self.trialSubscribtionView.addTapGesture(target: self, action: #selector(subscriptionViewTapped))
        self.notTrialSubscribtionView.addTapGesture(target: self, action: #selector(subscriptionViewTapped))
        
    }
    
    // MARK: - Gesture actions
    
    @objc private func subscriptionViewTapped(_ sender: UITapGestureRecognizer) {
        
        if sender.view == trialSubscribtionView {
            
            selectedProduct = trialProduct
            
            self.trialSubscribtionView.setBorder(width: 1, color: .NHOrange)
            self.notTrialSubscribtionView.setBorder(width: 0, color: .NHOrange)
            self.trialSubscribtionInnerCircleView.show()
            self.notTrialSubscribtionInnerCircleView.hide()
            
            return
        }
        
        if sender.view == notTrialSubscribtionView {
            
            selectedProduct = notTrialProduct
            
            self.trialSubscribtionView.setBorder(width: 0, color: .NHOrange)
            self.notTrialSubscribtionView.setBorder(width: 1, color: .NHOrange)
            self.trialSubscribtionInnerCircleView.hide()
            self.notTrialSubscribtionInnerCircleView.show()
            return
        }
        
    }
    
    @objc private func subscribeButtonViewTapped(_ sender: Any) {
        
        self.subscribeButtonView.flash()
        
        guard let product = selectedProduct else {
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
