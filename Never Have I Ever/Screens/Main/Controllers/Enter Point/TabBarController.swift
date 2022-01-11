import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        localize()
    }
    
    // MARK: - Custom functions
    
    private func configureUI() {
        
    }
    
    private func localize() {
        self.tabBar.items?[0].title = localized("tabbar.tab.0")
        self.tabBar.items?[1].title = localized("tabbar.tab.1")
        self.tabBar.items?[2].title = localized("tabbar.tab.2")
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
