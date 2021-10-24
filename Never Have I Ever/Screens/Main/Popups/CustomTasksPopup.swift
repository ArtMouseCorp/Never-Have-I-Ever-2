import UIKit

class CustomTasksPopup: BasePopupViewController {

    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var backgroundView: UIView!
    
    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var addButton: NHButton!
    @IBOutlet weak var closeButton: NHButton!
    
    // TableView
    @IBOutlet weak var tableView: UITableView!
    
    // Constraints
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    
    var customTasks: [TaskDB] = []
    var selectedTasks: [TaskDB] = []
    
    var onAddButtonPress: ((_ type: CustomTaskPopup.CustomTaskPopupType, _ task: TaskDB?) -> ())? = nil
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.configure(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchData()
        
    }
    
    // MARK: - Custom functions
    
    override func localize() {
        titleLabel.localize(with: "customTasks.title")
        addButton.localize(with: "button.customTasks.add")
        closeButton.localize(with: "button.customTasks.close")
    }
    
    override func configureUI() {
        super.configureUI()
        
        backgroundView.roundCorners(radius: 15)
        backgroundView.clipsToBounds = true
        
        addButton.initialize(as: .filled)
        addButton.addImage(.Icons.plus)
        
        closeButton.initialize(as: .outlined)
        closeButton.addImage(.Icons.smallClose)
    }
    
    override func setupGestures() {
        super.setupGestures()
    }
    
    private func fetchData() {
        
        DatabaseManager.shared.getTasks { isSuccess, tasks in
            if isSuccess, let tasks = tasks {
                
                DispatchQueue.main.async {
                    self.customTasks = tasks
                    self.selectedTasks = tasks.filter { $0.isSelected }
                    self.tableView.reloadData()
                    self.updateTableViewHeight(animated: false)
                }
                
                
            }
        }
        
    }
    
    private func updateTableViewHeight(animated: Bool) {
        UIView.animate(withDuration: animated ? 0.25 : 0) {
            
            if self.customTasks.isEmpty {
                self.backgroundView.hide()
            } else {
                self.backgroundView.show()
            }
            
            self.tableViewHeightConstraint.constant = self.tableView.contentHeight < 234 ? self.tableView.contentHeight : 234
            self.view.layoutIfNeeded()
        }

    }
    
    // MARK: - Gesture actions
    
    // MARK: - @IBActions
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let taskPopup = CustomTaskPopup.load(from: Popup.customTask)
        taskPopup.type = .new
        taskPopup.task = nil
        taskPopup.onConfirmButtonPress = { self.fetchData() }
        self.showPopup(taskPopup)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.view.removeFromSuperview()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CustomTasksPopup: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.customTask.id, for: indexPath) as! CustomTaskTableViewCell
        
        let task = customTasks[indexPath.row]
        
        cell.configure(name: task.name ?? "", selected: selectedTasks.contains(task))
        cell.onSwitchTap = {
            
            if let index = self.selectedTasks.firstIndex(of: task) {
                cell.select(false)
                DatabaseManager.shared.selectTask(task, isSelected: false)
                self.selectedTasks.remove(at: index)
            } else {
                cell.select()
                DatabaseManager.shared.selectTask(task)
                self.selectedTasks.append(task)
            }
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let task = customTasks[indexPath.row]
        
        self.onAddButtonPress?(.edit, task) ?? ()
        let taskPopup = CustomTaskPopup.load(from: Popup.customTask)
        taskPopup.type = .edit
        taskPopup.task = task
        
        taskPopup.onConfirmButtonPress = { self.fetchData() }
        
        self.showPopup(taskPopup)
        
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                // delete the item here
                
                let task = self.customTasks[indexPath.row]
                DatabaseManager.shared.deleteData(task: task)
                self.customTasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.updateTableViewHeight(animated: true)
                
                completionHandler(true)
            }
                
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
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
