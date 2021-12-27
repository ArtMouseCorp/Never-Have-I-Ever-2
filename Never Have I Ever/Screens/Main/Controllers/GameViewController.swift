import UIKit
import StoreKit
import Amplitude

class GameViewController: BaseViewController {
    
    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var orangeTitleView: UIView!
    
    // Labels
    @IBOutlet weak var whiteTitleLabel: UILabel!
    @IBOutlet weak var orangeTitleLabel: UILabel!
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var levelNameLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var manualButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    
    // MARK: - Variables
    
    var customTasks: [TaskDB] = []
    var tasks: [Task] = []
    
    var counter: Int = 0
    
    var isLiked: Bool = false
    var isDisliked: Bool = false
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTasks()
        StoreManager.updateStatus()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.configureRateButtons), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        lockOrientation([.portrait, .landscape])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // MARK: - Custom functions
    
    override func localize() {
        whiteTitleLabel.localize(with: "game.whiteTitle")
        orangeTitleLabel.localize(with: "game.orangeTitle")
    }
    
    override func configureUI() {
        super.configureUI()
        
        orangeTitleView.roundCorners(radius: 8)
        likeButton.capsuleCorners()
        dislikeButton.capsuleCorners()
        
        configureRateButtons()
    }
    
    override func setupGestures() {
        super.setupGestures()
    }
    
    private func fetchCustomTasks(completion: @escaping (() -> ())) {
        
        DatabaseManager.shared.getTasks { isSuccess, tasks in
            if isSuccess, let tasks = tasks {
                
                DispatchQueue.main.async {
                    self.customTasks = tasks
                    completion()
                }
            }
        }
        
    }
    
    private func loadTasks() {
        
        self.tasks.removeAll()
        
        fetchCustomTasks {
            
            // Append custom tasks
            
            let selectedCustomTasks = self.customTasks.filter { customTask in
                
                let isSelectedLevel = State.shared.selectedLevels.contains(where: { $0.id == customTask.levelId })
                
                return customTask.isSelected && isSelectedLevel
            }.map({ customTask -> Task in
                var level = Level.all[0]
                if let taskLevel = Level.all.first(where: { $0.id == customTask.levelId }) {
                    level = taskLevel
                }
                
                let task = Task(name: customTask.name ?? "", level: level)
                return task
            })
            
            print("Custom tasks: ", selectedCustomTasks)
            
            self.tasks.append(contentsOf: selectedCustomTasks)
            
            // Append standard tasks
            
            State.shared.selectedLevels.forEach { level in
                self.tasks.append(contentsOf: level.getTasks())
            }
            
            self.tasks.shuffle()
            
            self.loadNextTask()
            
        }
        
    }
    
    private func loadNextTask() {
        
        guard counter < self.tasks.count else {
            let gameOver = GameOverViewController.load(from: Main.gameover)
            gameOver.modalPresentationStyle = .fullScreen
            self.present(gameOver, animated: true) {
                self.navigationController?.popViewController(animated: false)
            }
            
            Amplitude.instance().logEvent("Game over", withEventProperties: ["tasksCompleted": tasks.count])
            
            return
        }
        
        if counter == State.shared.subscriptionConfig.freeTasksCount && !State.shared.isSubscribed {
            
            let paywall = SubscriptionViewController.load(from: Main.subscription)
            paywall.modalPresentationStyle = .fullScreen
            paywall.showNotification = {
                let content = UNMutableNotificationContent()
                content.title = "🎁 A special gift for you!"
                content.body = "Open the app and receive it"
                
                content.sound = UNNotificationSound.default
                
                // show this notification five seconds from now
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                
                // choose a random identifier
                let request = UNNotificationRequest(identifier: "ChristmasNotificationID", content: content, trigger: trigger)
                
                // add our notification request
                UNUserNotificationCenter.current().add(request)
            }
            self.present(paywall, animated: true)
            return
        }
        
        self.isLiked = false
        self.isDisliked = false
        
        self.configureRateButtons()
        
        self.taskNameLabel.text = self.tasks[counter].name
        self.levelNameLabel.text = self.tasks[counter].level.name
        
        if (counter == 1 || counter == 5) && State.shared.isSubscribed {
            SKStoreReviewController.requestReview()
        }
        
        counter += 1
        
    }
    
    @objc private func configureRateButtons() {
        likeButton.backgroundColor = isLiked ? UIColor(red: 0.961, green: 0.592, blue: 0.196, alpha: 1) : .clear
        dislikeButton.backgroundColor = isDisliked ? UIColor(red: 0.847, green: 0.129, blue: 0.129, alpha: 1) : .clear
    }
    
    // MARK: - Gesture actions
    
    // MARK: - @IBActions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        let quitPopup = QuitPopup.load(from: Popup.quit)
        
        quitPopup.onQuitButtonPress = {
            self.navigationController?.popViewController(animated: true)
            Amplitude.instance().logEvent("Game quited", withEventProperties: ["tasksCompleted": self.counter])
        }
        
        self.showPopup(quitPopup)
        
    }
    
    @IBAction func manualButtonPressed(_ sender: Any) {
        let manualVC = ManualViewConrtoller.load(from: Main.manual)
        self.navigationController?.pushViewController(manualVC, animated: true)
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        
        self.isLiked = !self.isLiked
        self.isDisliked = false
        
        configureRateButtons()
        
        Amplitude.instance().logEvent("Like \(self.isLiked ? "pressed" : "unpressed")", withEventProperties: [
            "Category": self.tasks[counter - 1].level.name,
            "Task": self.tasks[counter - 1].name
        ])
    }
    
    @IBAction func dislikeButtonPressed(_ sender: Any) {
        
        self.isDisliked = !self.isDisliked
        self.isLiked = false
        
        configureRateButtons()
        
        Amplitude.instance().logEvent("Dislike \(self.isDisliked ? "pressed" : "unpressed")", withEventProperties: [
            "Category": self.tasks[counter - 1].level.name,
            "Task": self.tasks[counter - 1].name
        ])
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        loadNextTask()
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
