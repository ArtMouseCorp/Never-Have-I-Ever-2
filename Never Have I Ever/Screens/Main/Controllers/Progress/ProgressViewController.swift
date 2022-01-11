import UIKit

class ProgressViewController: BaseViewController {
    
    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var backgroundView: UIView!
    
    // Labels
    @IBOutlet weak var myProgressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var galeryLabel: UILabel!
    @IBOutlet weak var cardUnlockedLabel: UILabel!
    @IBOutlet weak var customCardCreatedLabel: UILabel!
    @IBOutlet weak var cardUnlockedNumberLabel: UILabel!
    @IBOutlet weak var customCardCreatedNumberLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var demonstrationButton: UIButton!
    
    // Progress Views
    @IBOutlet weak var cardUnlockedProgressView: UIProgressView!
    @IBOutlet weak var cardCreatedProgressView: UIProgressView!
    
    // Collection Views
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    
    var collectionViewData: [ProgressImage]?
    
    var isDeleteMode: Bool = false
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(collectionView, with: Cell.progressImages)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchImages()
    }
    
    // MARK: - Custom functions
    
    override func configureUI() {
        backgroundView.roundCorners(radius: 40, corners: .topLeft, .topRight)
        configureProgress()
    }
    
    override func localize() {
        myProgressLabel.localize(with: "label.progress.my")
        descriptionLabel.localize(with: "label.progress.description")
        galeryLabel.localize(with: "label.progress.gallery")
        demonstrationButton.localize(with: "button.progress.show.demo")
        cardUnlockedLabel.localize(with: "label.progress.card.unlocked")
        customCardCreatedLabel.localize(with: "label.progress.card.created")
    }
    
    private func configureProgress() {
        guard let shownTasksCount = userDefaults.array(forKey: UDKeys.shownTasks)?.count else {
            fetchData()
            return
        }
        cardUnlockedNumberLabel.text = "\(shownTasksCount)/\(getCountOfAllLevels())"
        cardUnlockedProgressView.progress = Float(shownTasksCount) / Float(getCountOfAllLevels())
        fetchData()
    }
    
    private func getCountOfAllLevels() -> Int {
        var taskCount = 0
        for level in Level.all {
            taskCount += level.taskNames.count
        }
        return taskCount
    }
    
    private func fetchData() {
        DatabaseManager.shared.getTasks { isSuccess, tasks in
            if isSuccess, let tasks = tasks {
                DispatchQueue.main.async {
                    self.customCardCreatedNumberLabel.text = "\(tasks.count)/300"
                    self.cardCreatedProgressView.progress = Float(tasks.count) / 300
                }
            }
        }
    }
    
    func fetchImages() {
        do {
            self.collectionViewData = try super.context.fetch(ProgressImage.fetchRequest())
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        catch { }
    }
    
    // MARK: - @IBActions
    
    @IBAction func showDemoButtonPressed(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
        let popup = DemoImagePopup.load(from: Popup.demoImage)
        self.addChild(popup)
        popup.view.frame = self.view.frame
        popup.onPopupClose = {
            self.tabBarController?.tabBar.isHidden = false
        }
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(popup.view)
        }, completion: nil)
        
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        let settingsVC = SettingsViewConrtoller.load(from: Main.setting)
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension ProgressViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.collectionViewData?.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.progressImages.id, for: indexPath) as! ProgressCollectionViewCell
        
        if indexPath.row == 0 {
            let imageName = "add.photo.\(State.shared.getLanguageCode())"
            cell.mainImageView.image = UIImage(named: imageName)
            cell.showDeleteButton(false)
            
        } else {
            
            cell.onLongPress = {
                
                guard !self.isDeleteMode else { return }
                
                let impactFeedbackGenerator = UIImpactFeedbackGenerator()
                impactFeedbackGenerator.impactOccurred()
                self.isDeleteMode = true
                self.collectionView.reloadData()
            }
            
            cell.onDeleteButtonPress = {
                
                let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
                selectionFeedbackGenerator.selectionChanged()
                
                let alert = UIAlertController(title: localized("alert.delete.title"), message: localized("alert.delete.message"), preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: localized("alert.action.cancel"), style: .cancel)
                let deleteAction = UIAlertAction(title: localized("alert.action.delete"), style: .destructive) { _ in
                    
                    let selectedData = self.collectionViewData?[indexPath.row - 1]
                    
                    self.context.delete(selectedData!)
                    self.collectionViewData?.remove(at: indexPath.row - 1)
                    
                    do {
                        try self.context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    collectionView.deleteItems(at: [indexPath])
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.collectionView.reloadData()
                    }
                    
                }
                
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)
                
                self.present(alert, animated: true)
                
            }
            
            cell.mainImageView.image = UIImage(data: (self.collectionViewData?[indexPath.row - 1].image)!)
            cell.showDeleteButton(self.isDeleteMode)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 116)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            if isDeleteMode {
                isDeleteMode = false
                self.collectionView.reloadData()
            }
            
            super.takePhoto()
        } else {
            
            guard !isDeleteMode else {
                isDeleteMode = false
                self.collectionView.reloadData()
                return
            }
            
            self.tabBarController?.tabBar.isHidden = true
            let cell = collectionView.cellForItem(at: indexPath) as! ProgressCollectionViewCell
            
            let popup = ImagePopup.load(from: Popup.image)
            popup.mainImage = cell.mainImageView.image
            self.addChild(popup)
            popup.view.frame = self.view.frame
            popup.onPopupClose = {
                self.tabBarController?.tabBar.isHidden = false
            }
            UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                self.view.addSubview(popup.view)
            }, completion: nil)
            
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
