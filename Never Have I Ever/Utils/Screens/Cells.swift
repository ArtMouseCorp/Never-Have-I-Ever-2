import UIKit

public enum Cell: String {
    
    case levelCollection    = "LevelCollectionViewCell"
    case levelTable         = "LevelTableViewCell"
    case language           = "LanguageTableViewCell"
    case customTask         = "CustomTaskTableViewCell"
    
}

extension Cell {
    var id: String {
        return self.rawValue
    }
    
    var nib: UINib {
        return UINib(nibName: self.id, bundle: nil)
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
