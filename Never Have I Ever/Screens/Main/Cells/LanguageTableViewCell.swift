import UIKit

class LanguageTableViewCell: UITableViewCell {

    // MARK: - @IBOutlets
    
    // Labels
    @IBOutlet weak var languageName: UILabel!
    
    // Image Views
    @IBOutlet weak var languageImageView: UIImageView!
    
    // MARK: - Variables
    
    // MARK: - Awake functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Custom functions
    
    public func configure(with language: Language) {
        self.languageName.text = language.name
        self.languageImageView.image = language.image
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
