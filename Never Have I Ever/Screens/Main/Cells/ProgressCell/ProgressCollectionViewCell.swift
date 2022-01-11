import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var underImageView: UIView!
    
    // Image Views
    @IBOutlet weak var mainImageView: UIImageView!
    
    // MARK: - Variables
    
    
    var deleteButtonView: UIView = UIView();
    
    public var onDeleteButtonPress: (() -> ())? = nil
    public var onLongPress: (() -> ())? = nil
    
    // MARK: - Awake functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        setupGestures();
        mainImageView.layer.cornerRadius = 8
    }
    
    func configureUI() {
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.contentView.clipsToBounds = false
        self.contentView.layer.masksToBounds = false
        
        roundCorners(radius: 12, corners: .allCorners)
        
        underImageView.roundCorners(radius: 8, corners: .allCorners)
        
        underImageView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        underImageView.layer.shadowOpacity = 0.2
        underImageView.layer.shadowRadius = 2
        underImageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        configureDeleteButton()
    }
    
    private func setupGestures() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed))
        self.contentView.addGestureRecognizer(longPressRecognizer)
    }
    
    private func configureDeleteButton() {
        
        deleteButtonView.frame = CGRect(x: underImageView.frame.width - 12 - 6, y: -12 + 6, width: 24, height: 24)
        
        let deleteImageView = UIImageView(image: UIImage(systemName: "xmark.circle.fill"))
        deleteImageView.frame = CGRect(x: 0, y: 0, width: deleteButtonView.frame.width, height: deleteButtonView.frame.height)
        deleteImageView.tintColor = .NHRed
        
        deleteButtonView.addSubview(deleteImageView)
        
        deleteImageView.topAnchor.constraint(equalTo: deleteButtonView.topAnchor).isActive = true
        deleteImageView.trailingAnchor.constraint(equalTo: deleteButtonView.trailingAnchor).isActive = true
        deleteImageView.bottomAnchor.constraint(equalTo: deleteButtonView.bottomAnchor).isActive = true
        deleteImageView.leadingAnchor.constraint(equalTo: deleteButtonView.leadingAnchor).isActive = true
        deleteImageView.widthAnchor.constraint(equalTo: deleteButtonView.widthAnchor).isActive = true
        deleteImageView.heightAnchor.constraint(equalTo: deleteButtonView.heightAnchor).isActive = true
        
        deleteImageView.addTapGesture(target: self, action: #selector(self.deleteButtonPressed))
        
        underImageView.addSubview(deleteButtonView)
        
        self.showDeleteButton(false)
    }
    
    public func showDeleteButton(_ bool: Bool = true) {
        self.deleteButtonView.hide(!bool)
    }
    
    // MARK: - Gesture actions
    
    @objc public func longPressed() {
        self.onLongPress?() ?? ()
    }
    
    @objc private func deleteButtonPressed() {
        self.onDeleteButtonPress?() ?? ()
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
