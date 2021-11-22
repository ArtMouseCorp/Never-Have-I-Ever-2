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
    
    // MARK: - Variables
    
    var customTasks: [TaskDB] = []
    var tasks: [Task] = []
    
    var counter: Int = 0
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTasks()
        StoreManager.updateStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        lockOrientation([.portrait, .landscape])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    // MARK: - Custom functions
    
    override func localize() {
        whiteTitleLabel.localize(with: "game.whiteTitle")
        orangeTitleLabel.localize(with: "game.orangeTitle")
    }
    
    override func configureUI() {
        super.configureUI()
        
        orangeTitleView.roundCorners(radius: 8)
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
            
            Amplitude.instance().logEvent("Game over", withEventProperties: ["onTaskNumber": tasks.count])
            
            return
        }
        
        if counter == State.shared.subscriptionConfig.freeTasksCount && !State.shared.isSubscribed {
            let paywall = SubscriptionViewConrtoller.load(from: Main.subscription)
            paywall.modalPresentationStyle = .fullScreen
            self.present(paywall, animated: true)
            return
        }
        
        self.taskNameLabel.text = self.tasks[counter].name
        self.levelNameLabel.text = self.tasks[counter].level.name
        
        if (counter == 1 || counter == 5) && State.shared.isSubscribed {
            SKStoreReviewController.requestReview()
        }
        
        counter += 1
        
    }
    
    // MARK: - Gesture actions
    
    // MARK: - @IBActions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        Amplitude.instance().logEvent("Game quited", withEventProperties: ["onTaskNumber": self.counter + 1])
    }
    
    @IBAction func manualButtonPressed(_ sender: Any) {
        let manualVC = ManualViewConrtoller.load(from: Main.manual)
        self.navigationController?.pushViewController(manualVC, animated: true)
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
