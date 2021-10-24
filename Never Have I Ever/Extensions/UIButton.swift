import UIKit

extension UIButton {

    public func localize(with key: String) {
        self.setTitle(localized(key), for: .normal)
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
