import UIKit

class LoadingViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var progressView: UIView!
    
    // MARK: - Variables
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startLoading()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let homeNav = UINavigationController.load(from: Main.homeNav)
            homeNav.modalPresentationStyle = .fullScreen
            self.present(homeNav, animated: true)
        }
    }
    
    // MARK: - Custom functions
    
    override func configureUI() {
        super.configureUI()
        
        progressView.capsuleCorners()
    }
    
    private func fetchData() {
     
        SubscriptionConfig.get()
        Level.get()
        
    }
    
    private func startLoading() {
        
        let view = UIView()
        
        view.frame = CGRect(x: 0, y: 0, width: 0, height: progressView.frame.height)
        
        view.backgroundColor = .NHOrange
        view.capsuleCorners()
        
        progressView.addSubview(view)
        
        UIView.animate(withDuration: 2) {
            view.frame.size.width = self.progressView.frame.width
        }
        
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
