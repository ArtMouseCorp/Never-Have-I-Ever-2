import UIKit

class LevelTableViewCell: UITableViewCell {

    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var cellBackbgroundView: UIView!
    
    // Labels
    @IBOutlet weak var levelNameLabel: UILabel!
    
    // ImageViews
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    // MARK: - Variables
    
    // MARK: - Awake functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Custom functions
    
    public func configure(with level: Level, isSelected: Bool) {
        self.levelNameLabel.text = level.name
        self.checkmarkImageView.hide(!isSelected)
        self.backgroundColor = isSelected ? .NHDarkGray : .clear
        
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
