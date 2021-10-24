import UIKit

class LevelCollectionViewCell: UICollectionViewCell {

    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var bottomTapView: UIView!
    
    // Labels
    @IBOutlet weak var levelNameLabel: UILabel!
    
    // Image Views
    @IBOutlet weak var levelImageView: UIImageView!
    @IBOutlet weak var checkboxImageView: UIImageView!
    
    // MARK: - Variables
    
    var level: Level?
    var onBottomViewTap: (() -> ()) = {}
    
    // MARK: - Awake functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGestures()
    }
    
    // MARK: - Custom functions
    
    public func configure(with level: Level, selected: Bool) {
        
        self.level = level
        
        levelNameLabel.text = level.name
        levelImageView.image = UIImage(named: level.image)
        
        cellBackgroundView.roundCorners(radius: 15)
        cellBackgroundView.setBorder(width: 1, color: selected ? .NHOrange : .NHDarkGray)
        
        checkboxImageView.image = selected ? .Icons.checkedCircle : .Icons.emptyCircle
    }
    
    private func setupGestures() {
        bottomTapView.addTapGesture(target: self, action: #selector(bottomViewTapped))
    }
    
    public func select(_ select: Bool = true) {
        cellBackgroundView.setBorder(width: 1, color: select ? .NHOrange : .NHDarkGray)
        checkboxImageView.image = select ? .Icons.checkedCircle : .Icons.emptyCircle
    }
    
    // MARK: - Gesture actions
    
    @objc private func bottomViewTapped() {
        self.onBottomViewTap()
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
