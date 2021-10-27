import UIKit

class ManualViewConrtoller: BaseViewController {
    
    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet var manualStepViews: [UIView]!
    
    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var manualStepLabels: [UILabel]!
    
    // Buttons
    @IBOutlet weak var backButton: UIButton!
    
    
    // MARK: - Variables
    
    var isViewDidLayoutSubviews: Bool = false
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        guard !isViewDidLayoutSubviews else { return }
        isViewDidLayoutSubviews = true
    }
    
    // MARK: - Custom functions
    
    override func localize() {
        titleLabel.localize(with: "manual.title")
        manualStepLabels[0].localize(with: "manual.step.first")
        manualStepLabels[1].localize(with: "manual.step.second")
        manualStepLabels[2].localize(with: "manual.step.third")
        manualStepLabels[3].localize(with: "manual.step.fourth")
        manualStepLabels[4].localize(with: "manual.step.fifth")
    }
    
    override func configureUI() {
        super.configureUI()
        
        self.manualStepViews.forEach { $0.roundCorners(radius: 20) }
    }
    
    // MARK: - @IBActions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
