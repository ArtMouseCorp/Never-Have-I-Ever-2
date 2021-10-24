import UIKit

extension UICollectionView {
    
    func registerCell(cell: Cell) {
        self.register(cell.nib, forCellWithReuseIdentifier: cell.rawValue)
    }
    
    public var contentHeight: CGFloat {
        self.layoutIfNeeded()
        return self.contentSize.height
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
