import UIKit

class SubscriptionViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var firstProductView: UIView!
    @IBOutlet weak var firstProductOuterCircleView: UIView!
    @IBOutlet weak var firstProductInnerCircleView: UIView!
    
    @IBOutlet weak var secondProductView: UIView!
    @IBOutlet weak var secondProductOuterCircleView: UIView!
    @IBOutlet weak var secondProductInnerCircleView: UIView!
    
    @IBOutlet weak var saveAmountView: UIView!
    @IBOutlet weak var subscribeButtonView: UIView!
    
    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var trialPeriodLabel: UILabel!
    @IBOutlet var reasonLabels: [UILabel]!
    
    @IBOutlet weak var firstProductTitleLabel: UILabel!
    @IBOutlet weak var firstProductTrialLabel: UILabel!
    @IBOutlet weak var firstProductPriceLabel: UILabel!
    
    @IBOutlet weak var secondProductTitleLabel: UILabel!
    @IBOutlet weak var secondProductTrialLabel: UILabel!
    @IBOutlet weak var secondProductPriceLabel: UILabel!
    
    @IBOutlet weak var saveAmountLabel: UILabel!
    @IBOutlet weak var subscribeButtonLabel: UILabel!
    
    
    // Buttons
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    
    // Stack Views
    @IBOutlet weak var firstProductInfoStackView: UIStackView!
    @IBOutlet weak var secondProductInfoStackView: UIStackView!
    
    
    // Activity Indicators
    @IBOutlet weak var trialActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reasonsActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var firstProductActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var secondProductActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var subscribeActivityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Variables
    
    var firstProduct: StoreManager.Product?
    var secondProduct: StoreManager.Product?
    var selectedProduct: StoreManager.Product?
    var showNotification: (()->()) = {}
    
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
        
        firstProductView.roundCorners(radius: 15)
        
        secondProductView.roundCorners(radius: 15)
        
        firstProductOuterCircleView.capsuleCorners()
        firstProductOuterCircleView.setBorder(width: 1, color: .NHWhite)
        firstProductOuterCircleView.backgroundColor = .clear
        
        firstProductInnerCircleView.capsuleCorners()
        
        secondProductOuterCircleView.capsuleCorners()
        secondProductOuterCircleView.setBorder(width: 1, color: .NHWhite)
        secondProductOuterCircleView.backgroundColor = .clear
        
        secondProductInnerCircleView.capsuleCorners()
        
        closeButton.hide(!State.shared.subscriptionConfig.showCloseButton)
        
        saveAmountView.roundCorners(radius: 5)
        
        titleLabel.hide()
        trialPeriodLabel.hide()
        reasonLabels.forEach { $0.hide() }
        
        saveAmountView.hide()
        
        firstProductOuterCircleView.hide()
        firstProductInnerCircleView.hide()
        secondProductOuterCircleView.hide()
        secondProductInnerCircleView.hide()
        
        firstProductInfoStackView.hide()
        secondProductInfoStackView.hide()
        
        firstProductPriceLabel.hide()
        secondProductPriceLabel.hide()
        
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
            State.shared.subscriptionConfig.firstProduct.productId,
            State.shared.subscriptionConfig.secondProduct.productId
        ]
        
        
        StoreManager.getProducts(for: productIds) { products in
            
            guard products.count == 2 else {
                self.dismiss(animated: true)
                return
            }
            
            self.firstProduct = products[0]
            self.secondProduct = products[1]
            self.selectedProduct = self.firstProduct
            
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
            let firstProduct = firstProduct,
            let secondProduct = secondProduct
        else {
            return
        }
        
        if let trialPeriod = firstProduct.trialPeriod {
            
            self.trialPeriodLabel.text = State.shared.subscriptionConfig.trialPeriodTitle
                .replacingOccurrences(of: "%trial_period%", with: trialPeriod)
            
            self.firstProductTitleLabel.text = State.shared.subscriptionConfig.firstProduct.title
            
            self.firstProductTrialLabel.show()
            self.firstProductTrialLabel.text = State.shared.subscriptionConfig.firstProduct.subtitle
                .replacingOccurrences(of: "%trial_period%", with: trialPeriod)
            
            self.firstProductPriceLabel.text = "\(firstProduct.price)/\(firstProduct.subscriptionPeriod)"
            
        } else {
            
            self.trialPeriodLabel.text = ""
            
            self.firstProductTitleLabel.text = State.shared.subscriptionConfig.firstProduct.title
            
            self.firstProductTrialLabel.hide()
            
            self.firstProductPriceLabel.text = "\(firstProduct.price)/\(firstProduct.subscriptionPeriod)"
        }
        
        if let trialPeriod = secondProduct.trialPeriod {
            
            self.secondProductTitleLabel.text = State.shared.subscriptionConfig.secondProduct.title
            
            self.secondProductTrialLabel.show()
            self.secondProductTrialLabel.text = State.shared.subscriptionConfig.secondProduct.subtitle
                .replacingOccurrences(of: "%trial_period%", with: trialPeriod)
            
            self.secondProductPriceLabel.text = "\(secondProduct.price)/\(secondProduct.subscriptionPeriod)"
            
        } else {
            
            self.secondProductTitleLabel.text = State.shared.subscriptionConfig.secondProduct.title
            
            self.secondProductTrialLabel.hide()
            
            self.secondProductPriceLabel.text = "\(secondProduct.price)/\(secondProduct.subscriptionPeriod)"
            
        }
        
        if let saveLabel = State.shared.subscriptionConfig.firstProduct.saveLabel {
            self.saveAmountLabel.text = saveLabel
            self.saveAmountView.show()
        }
        
        self.subscribeButtonLabel.text = State.shared.subscriptionConfig.buttonTitle
        
        self.trialActivityIndicator.stopAnimating()
        self.firstProductActivityIndicator.stopAnimating()
        self.secondProductActivityIndicator.stopAnimating()
        self.subscribeActivityIndicator.stopAnimating()
        
        self.firstProductView.setBorder(width: 1, color: .NHOrange)
        
        self.firstProductOuterCircleView.show()
        self.firstProductInnerCircleView.show()
        self.secondProductOuterCircleView.show()
        
        self.firstProductInfoStackView.show()
        self.secondProductInfoStackView.show()
        
        self.firstProductPriceLabel.show()
        self.secondProductPriceLabel.show()
        
        self.trialPeriodLabel.colorText(from: "<h>", to: "</h>", color: .NHOrange)
        self.trialPeriodLabel.uppercase()
        self.trialPeriodLabel.show()
        self.subscribeButtonLabel.show()
        self.restoreButton.isEnabled = true
        
        self.subscribeButtonView.addTapGesture(target: self, action: #selector(subscribeButtonViewTapped))
        self.firstProductView.addTapGesture(target: self, action: #selector(subscriptionViewTapped))
        self.secondProductView.addTapGesture(target: self, action: #selector(subscriptionViewTapped))
        
    }
    
    // MARK: - Gesture actions
    
    @objc private func subscriptionViewTapped(_ sender: UITapGestureRecognizer) {
        
        if sender.view == firstProductView {
            
            selectedProduct = firstProduct
            
            self.firstProductView.setBorder(width: 1, color: .NHOrange)
            self.secondProductView.setBorder(width: 0, color: .NHOrange)
            self.firstProductInnerCircleView.show()
            self.secondProductInnerCircleView.hide()
            
            return
        }
        
        if sender.view == secondProductView {
            
            selectedProduct = secondProduct
            
            self.firstProductView.setBorder(width: 0, color: .NHOrange)
            self.secondProductView.setBorder(width: 1, color: .NHOrange)
            self.firstProductInnerCircleView.hide()
            self.secondProductInnerCircleView.show()
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
        showNotification()
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
