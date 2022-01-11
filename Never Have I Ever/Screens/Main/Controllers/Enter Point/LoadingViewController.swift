import UIKit

class LoadingViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var progressView: UIView!
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startLoading()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let tabBarController = UITabBarController.load(from: Main.tabBar)
            tabBarController.modalPresentationStyle = .fullScreen
            self.present(tabBarController, animated: true)
        }
    }
    
    // MARK: - Custom functions
    
    override func configureUI() {
        super.configureUI()
        progressView.capsuleCorners()
    }
    
    private func fetchData() {
        State.shared.shownTasks = userDefaults.array(forKey: UDKeys.shownTasks) as? [String] ?? []
        SubscriptionConfig.get()
        Level.get()
        Joke.getAll()
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
