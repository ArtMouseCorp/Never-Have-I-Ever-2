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
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.configure(collectionView)
        
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
        
        let gameVC = GameViewController.load(from: Main.game)
        self.navigationController?.pushViewController(gameVC, animated: true)
        let properties = State.shared.selectedLevels.reduce([Int: String]()) { (dict, level) -> [Int: String] in
            var dict = dict
            dict[State.shared.selectedLevels.firstIndex(of: level) ?? 0] = level.name
            return dict
        }
        Amplitude.instance().logEvent("Play button pressed, selected levels:", withEventProperties: properties)
        
    }
    
    // MARK: - @IBActions
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        let settingsVC = SettingsViewConrtoller.load(from: Main.setting)
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @IBAction func customTasksButtonPressed(_ sender: Any) {
        // TODO: - Show popup
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
