import UIKit
import MessageUI
import Amplitude

class SettingsViewConrtoller: BaseViewController {

    // MARK: - @IBOutlets
    
    // Views
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var languageBackgroundView: UIView!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var restoreView: UIView!
    
    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var restoreLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var backButton: UIButton!
    
    // Image Views
    @IBOutlet weak var languageImageView: UIImageView!
    @IBOutlet weak var languageChevronImageView: UIImageView!
    
    // TableViews
    @IBOutlet weak var languageTableView: UITableView!
    
    // StackViews
    @IBOutlet weak var settingsStackView: UIStackView!
    
    // Constraints
    @IBOutlet weak var languageTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var languageTableViewTopConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    
    var languagesIsShown: Bool = false
    
    // MARK: - Awake functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.configure(languageTableView)
    }
    
    // MARK: - Custom functions
    
    override func localize() {
        titleLabel.localize(with: "settings.title")
        contactLabel.localize(with: "settings.contact")
        restoreLabel.localize(with: "settings.restore")
    }
    
    override func configureUI() {
        super.configureUI()
        
        languageView.roundCorners(radius: 15)
        contactView.roundCorners(radius: 15)
        restoreView.roundCorners(radius: 15)
        
        languageBackgroundView.roundCorners(radius: 15)
        languageBackgroundView.layer.masksToBounds = true
        languageBackgroundView.clipsToBounds = true
        
        languageTableViewTopConstraint.constant = 0
        languageTableViewHeightConstraint.constant = 0
        
        languageImageView.image = State.shared.getLanguageCode().getLanguage().image
        languageLabel.text = State.shared.getLanguageCode().getLanguage().name
    }
    
    override func setupGestures() {
        super.setupGestures()
        
        languageView.addTapGesture(target: self, action: #selector(languageViewTapped))
        contactView.addTapGesture(target: self, action: #selector(contactViewTapped))
        restoreView.addTapGesture(target: self, action: #selector(restoreViewTapped))
    }
    
    // MARK: - Gesture actions
    
    @objc private func languageViewTapped() {
        
        UIView.animate(withDuration: 0.2) {
            
            self.languageChevronImageView.transform = CGAffineTransform(rotationAngle: self.languagesIsShown ? 0 : CGFloat.pi)
            self.languageTableViewHeightConstraint.constant = self.languagesIsShown ? 0 : 300
            self.languageTableViewTopConstraint.constant = self.languagesIsShown ? 0 : 4
            self.view.layoutIfNeeded()
            
        } completion: { _ in
            self.languagesIsShown = !self.languagesIsShown
        }
        
    }
    
    @objc private func contactViewTapped() {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([Config.CONTACT_EMAIL])
            mail.setSubject("Never Have I Contact")
            mail.setMessageBody("", isHTML: true)

            present(mail, animated: true)
        } else {
            
            let okAction = UIAlertAction(title: localized("alert.action.ok"), style: .default)
            let alert = getAlert(title: localized("alert.mail.title"), message: nil, actions: okAction)
            self.present(alert, animated: true)
        }
        
    }
    
    @objc private func restoreViewTapped() {
        
        guard isConnectedToNetwork() else {
            self.showNetworkConnectionAlert()
            return
        }
        
        StoreManager.restore {
            self.dismiss(animated: true)
        }
        
    }
    
    // MARK: - @IBActions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SettingsViewConrtoller: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Language.languages.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.language.id, for: indexPath) as! LanguageTableViewCell
        
        let languages = Language.languages.filter { $0.code != State.shared.getLanguageCode() }
        
        cell.configure(with: languages[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let languages = Language.languages.filter { $0.code != State.shared.getLanguageCode() }
        let language = languages[indexPath.row]
        
        State.shared.setLanguage(to: language.code)
        languageViewTapped()
        tableView.reloadData()
        languageImageView.image = State.shared.getLanguageCode().getLanguage().image
        languageLabel.text = State.shared.getLanguageCode().getLanguage().name
        State.shared.shownTasks = []
        userDefaults.setValue(State.shared.shownTasks, forKey: UDKeys.shownTasks)
        localize()
        
        Amplitude.instance().logEvent("App language changed", withEventProperties: ["Changed to language": State.shared.getLanguageCode().getLanguage().name])
        
    }
    
}

// MARK: - MFMailComposeViewControllerDelegate

extension SettingsViewConrtoller: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
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
