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
    
    // Constraints
    @IBOutlet var manualStepLabelHeightConstraints: [NSLayoutConstraint]!
    
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Custom functions
    
    override func localize() {
        titleLabel.localize(with: "manual.title")
        manualStepLabels[0].localize(with: "manual.step.first")
        manualStepLabels[1].localize(with: "manual.step.second")
        manualStepLabels[2].localize(with: "manual.step.third")
        manualStepLabels[3].localize(with: "manual.step.fourth")
    }
    
    override func configureUI() {
        super.configureUI()
        
        
        DispatchQueue.main.async {
            for i in 0 ..< self.manualStepLabels.count {
                
                let label = self.manualStepLabels[i]
                let view = self.manualStepViews[i]
                let constraint = self.manualStepLabelHeightConstraints[i]
                
                constraint.constant = label.contentHeight(lineSpacing: 2)
                view.roundCorners(radius: 20)
                
            }
        }
        
        
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
