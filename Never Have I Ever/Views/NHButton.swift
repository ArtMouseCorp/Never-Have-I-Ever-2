import UIKit

class NHButton: UIButton {
    
    // MARK: - Variables
    
    internal enum NHButtonType {
        case filled, outlined
    }
    
    // MARK: - Awake functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    // MARK: - Custom functions
    
    private func configureUI() {
        self.roundCorners(radius: 15)
        self.titleLabel?.font = UIFont(name: "Arial-BoldMT", size: 18)
    }
    
    public func addImage(_ image: UIImage) {
        
        self.setImage(image, for: .normal)
        
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 7)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: -7)
        
    }
    
    public func initialize(as type: NHButtonType) {
        
        switch type {
        case .filled:
            
            self.backgroundColor = .NHOrange
            self.setTitleColor(.NHBlack, for: .normal)
            self.tintColor = .NHBlack
            self.setBorder(width: 0, color: .NHOrange)
            
        case .outlined:
            
            self.backgroundColor = .clear
            self.setTitleColor(.NHOrange, for: .normal)
            self.tintColor = .NHOrange
            self.setBorder(width: 1, color: .NHOrange)
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.flash()
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
