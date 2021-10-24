import UIKit

class CustomTaskPopup: BasePopupViewController {

    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var taskNameBackgroundView: UIView!
    @IBOutlet weak var levelBackgroundView: UIView!
    @IBOutlet weak var levelNameBackgroundView: UIView!
    
    // Labels
    @IBOutlet weak var levelNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var createButton: NHButton!
    @IBOutlet weak var cancelButton: NHButton!
    
    // ImageViews
    @IBOutlet weak var levelsImageView: UIImageView!
    
    // TableViews
    @IBOutlet weak var levelsTableView: UITableView!
    
    // TextFields
    @IBOutlet weak var taskNameTextField: UITextField!
    
    // Constraints
    @IBOutlet weak var levelsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var levelsTableViewBottomConstraint: NSLayoutConstraint!
    
    
    // MARK: - Variables
    
    internal enum CustomTaskPopupType {
        case new, edit
    }
    
    var type: CustomTaskPopupType = .new
    
    var task: TaskDB?
    
    var levelsIsShown: Bool = false
    var selectedLevel: Level? {
        didSet {
            self.levelNameLabel.text = selectedLevel?.name
        }
    }
    
    var onConfirmButtonPress: (() -> ()) = {}
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.configure(levelsTableView)
        taskNameTextField.delegate = self
    }
    
    // MARK: - Custom functions
    
    override func localize() {
        titleLabel.localize(with: "customTask.title")
        taskNameTextField.placeholder = localized("customTask.taskPlaceholder")
        levelNameLabel.localize(with: "customTask.selectLevel")
        createButton.localize(with: type == .new ? "button.customTask.add" : "button.customTask.save")
        cancelButton.localize(with: "button.customTask.cancel")
    }
    
    override func configureUI() {
        super.configureUI()
        
        taskNameBackgroundView.roundCorners(radius: 15)
        levelBackgroundView.roundCorners(radius: 15)
        levelBackgroundView.clipsToBounds = true
        
        createButton.initialize(as: .filled)
        createButton.addImage(.Icons.plus)
        
        cancelButton.initialize(as: .outlined)
        cancelButton.addImage(.Icons.smallClose)
        
        levelsTableViewBottomConstraint.constant = 0
        levelsTableViewHeightConstraint.constant = 0
        
        if let task = task, type == .edit {
            
            taskNameTextField.text = task.name
            selectedLevel = Level.all.first { $0.id == Int(task.levelId) }
            
        }
    }
    
    override func setupGestures() {
        super.setupGestures()
        
        levelNameBackgroundView.addTapGesture(target: self, action: #selector(levelNameBackgroundViewTapped))
    }
    
    // MARK: - Gesture actions
    
    @objc private func levelNameBackgroundViewTapped() {
        
        UIView.animate(withDuration: 0.2) {
            
            self.levelsImageView.transform = CGAffineTransform(rotationAngle: self.levelsIsShown ? 0 : CGFloat.pi)
            self.levelsTableViewHeightConstraint.constant = self.levelsIsShown ? 0 : 150
            self.levelsTableViewBottomConstraint.constant = self.levelsIsShown ? 0 : 8
            self.view.layoutIfNeeded()
            
        } completion: { _ in
            self.levelsIsShown = !self.levelsIsShown
        }
        
    }
    
    // MARK: - @IBActions
    
    @IBAction func createButtonPressed(_ sender: Any) {
        
        guard let taskName = taskNameTextField.text, !taskName.isEmpty, let selectedLevel = selectedLevel else {
            return
        }
        
        if let task = task, type == .edit {
            
            task.name = taskName
            task.levelId = Int16(selectedLevel.id)
            DatabaseManager.shared.updateTasks()
            self.view.removeFromSuperview()
            
        } else {
            
            DatabaseManager.shared.saveTask(name: taskName, levelId: selectedLevel.id) { isSuccess in
                if isSuccess {
    //                State.createdTasks.append(Task(name: text, level: level.name))
                }
                self.view.removeFromSuperview()
            }
            
        }
        
        self.onConfirmButtonPress()
           
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
}

// MARK: - UITextFieldDelegate

extension CustomTaskPopup: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CustomTaskPopup: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Level.all.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.levelTable.id, for: indexPath) as! LevelTableViewCell
        
        let level = Level.all[indexPath.row]
        
        let isSelected = selectedLevel == level
        
        cell.configure(with: level, isSelected: isSelected)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let level = Level.all[indexPath.row]
        selectedLevel = level
        levelNameBackgroundViewTapped()
        
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
