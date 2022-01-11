import UIKit
import Amplitude

class HomeViewController: BaseViewController {

    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var playButtonView: UIView!
    
    // Labels
    @IBOutlet weak var playLabel: UILabel!
    @IBOutlet weak var levelsLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var customTasksButton: UIButton!
    
    // CollectionViews
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    
    let cellWidth = UIScreen.main.bounds.width - 64
    var customTasks: [TaskDB] = []
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.configure(collectionView)
        showGiftScreen()
        Amplitude.instance().logEvent("Levels screen opened")
    }
    
    // MARK: - Custom functions
    
    override func localize() {
        playLabel.localize(with: "button.home.play")
    }
    
    override func configureUI() {
        super.configureUI()
        
        playButtonView.roundCorners(radius: 15)
        
        State.shared.selectedLevels.removeAll()
        updateSelectedLevelNames()
        
        DispatchQueue.main.async {
            self.configureCollectionView()            
        }
    }
    
    private func showGiftScreen() {
        if State.openChristmasSceen {
            State.openChristmasSceen = false
            let christmasVC = ChristmasViewController.load(from: Main.christmas)
            christmasVC.modalPresentationStyle = .fullScreen
            self.present(christmasVC, animated: true)
        }
    }
    
    override func setupGestures() {
        super.setupGestures()
        playButtonView.addTapGesture(target: self, action: #selector(playButtonViewTapped))
    }
    
    private func configureCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        let size = (collectionView.frame.width - 28 - 10) / 2
        
        layout.itemSize = CGSize(width: size, height: size)
         
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
        
    }
    
    private func updateSelectedLevelNames() {
        
        let levelNames = State.shared.selectedLevels.map { level in
            return level.name
        }
        
        if levelNames.isEmpty {
            self.levelsLabel.text = localized("home.noLevels")
        } else {
            self.levelsLabel.text = levelNames.joined(separator: ", ")
        }
        
    }
    
    // MARK: - Gesture actions
    
    @objc private func playButtonViewTapped() {
        
        guard !State.shared.selectedLevels.isEmpty else {
            return
        }
        
        playButtonView.flash()
        
        if State.shared.selectedLevels.contains(Level.all[6]) {
            State.shared.selectedLevels.removeAll()
            for i in 0..<6 {
                State.shared.selectedLevels.append(Level.all[i])
            }
        }
        
        if State.shared.selectedLevels.count == 1 && State.shared.selectedLevels.contains(Level.all[7]) {
            checkData()
        } else {
            let gameVC = GameViewController.load(from: Main.game)
            self.navigationController?.pushViewController(gameVC, animated: true)
            let properties = State.shared.selectedLevels.reduce([Int: String]()) { (dict, level) -> [Int: String] in
                var dict = dict
                dict[State.shared.selectedLevels.firstIndex(of: level) ?? 0] = level.name
                return dict
            }
            Amplitude.instance().logEvent("Play button pressed, selected levels:", withEventProperties: properties)
        }
    }
    
    private func checkData() {
        DatabaseManager.shared.getTasks { isSuccess, tasks in
            if isSuccess, let tasks = tasks {
                DispatchQueue.main.async {
                    for task in tasks {
                        if task.levelId == 8 {
                            let gameVC = GameViewController.load(from: Main.game)
                            self.navigationController?.pushViewController(gameVC, animated: true)
                            let properties = State.shared.selectedLevels.reduce([Int: String]()) { (dict, level) -> [Int: String] in
                                var dict = dict
                                dict[State.shared.selectedLevels.firstIndex(of: level) ?? 0] = level.name
                                return dict
                            }
                            Amplitude.instance().logEvent("Play button pressed, selected levels:", withEventProperties: properties)
                            return
                        }
                    }
                    let alert = UIAlertController(title: "Oops..", message: "You have no custom tasks, please add your custom tasks", preferredStyle: .alert)
                    let alertOkAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alert.addAction(alertOkAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    // MARK: - @IBActions
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        let manualVC = ManualViewConrtoller.load(from: Main.manual)
        self.navigationController?.pushViewController(manualVC, animated: true)
    }
    
    @IBAction func customTasksButtonPressed(_ sender: Any) {
        let tasksPopup = CustomTasksPopup.load(from: Popup.customTasks)
        self.showPopup(tasksPopup)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Level.all.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.levelCollection.id, for: indexPath) as! LevelCollectionViewCell
        
        let level = Level.all[indexPath.row]
        
        cell.configure(with: level, selected: false)
        cell.onBottomViewTap = {
            
            if let index = State.shared.selectedLevels.firstIndex(where: {$0.id == level.id}) {
                State.shared.selectedLevels.remove(at: index)
                cell.select(false)
            } else {
                State.shared.selectedLevels.append(level)
                cell.select()
            }
            self.updateSelectedLevelNames()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: - Open level popup
        
        let cell = collectionView.cellForItem(at: indexPath) as! LevelCollectionViewCell
        let level = Level.all[indexPath.row]
        
        let levelPopup = LevelPopup.load(from: Popup.level)
        
        levelPopup.isSelected = State.shared.selectedLevels.firstIndex(where: {$0.id == level.id}) != nil
        levelPopup.initialize(with: level)
        
        levelPopup.onSelectButtonPress = {
            
            if let index = State.shared.selectedLevels.firstIndex(where: {$0.id == level.id}) {
                State.shared.selectedLevels.remove(at: index)
                cell.select(false)
            } else {
                State.shared.selectedLevels.append(level)
                cell.select()
            }
            
            self.updateSelectedLevelNames()
            
        }
        
        self.showPopup(levelPopup)
        
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
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
