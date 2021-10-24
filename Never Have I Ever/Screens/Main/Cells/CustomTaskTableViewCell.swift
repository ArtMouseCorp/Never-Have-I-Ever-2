import UIKit

class CustomTaskTableViewCell: UITableViewCell {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var taskNameLabel: UILabel!
    
    // Image Views
    @IBOutlet weak var switchImageView: UIImageView!
    
    // MARK: - Variables
    
    var onSwitchTap: (() -> ()) = {}
    
    // MARK: - Awake functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGestures()
    }
    
    // MARK: - Custom functions
    
    public func configure(name: String, selected: Bool) {
        self.taskNameLabel.text = name
        switchImageView.image = selected ? .Icons.onSwitch : .Icons.offSwitch
    }
    
    private func setupGestures() {
        switchImageView.addTapGesture(target: self, action: #selector(switchTapped))
    }
    
    public func select(_ select: Bool = true) {
        switchImageView.image = select ? .Icons.onSwitch : .Icons.offSwitch
    }
    
    // MARK: - Gesture actions
    
    @objc private func switchTapped() {
        self.onSwitchTap()
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
