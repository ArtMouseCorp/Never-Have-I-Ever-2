import UIKit

extension UIViewController {
    
    public static func load(from screen: StoryboardScreen) -> Self {
        return screen.storyboard.instantiateViewController(withIdentifier: screen.id) as! Self
    }
    
    public func showPopup(_ popup: UIViewController) {
        self.addChild(popup)
        popup.view.frame = self.view.frame
        //        UIView.transition(with: self.view, duration: 0.25, options: [], animations: {
        self.view.addSubview(popup.view)
        //        }, completion: nil)
        popup.didMove(toParent: self)
    }
    
    public func showNetworkConnectionAlert(completion: (() -> ())? = nil) {
        let alertOk = UIAlertAction(title: localized("alert.action.ok"), style: .default) { _ in
            completion?() ?? ()
        }
        self.present(getAlert(title: localized("alert.connection.title"),
                              message: localized("alert.connection.message"),
                              actions: alertOk),
                     animated: true,
                     completion: nil
        )
    }
    
    public func showAlreadySubscribedAlert(completion: (() -> ())? = nil) {
        let alertOk = UIAlertAction(title: localized("alert.action.ok"), style: .default) { _ in
            completion?() ?? ()
        }
        self.present(getAlert(title: localized("alert.subscribed.title"),
                              message: localized("alert.subscribed.message"),
                              actions: alertOk),
                     animated: true,
                     completion: nil
        )
    }
    
    public func showNotSubscriberAlert(completion: (() -> ())? = nil) {
        let alertOk = UIAlertAction(title: localized("alert.action.ok"), style: .default) { _ in
            completion?() ?? ()
        }
        self.present(getAlert(title: localized("alert.notSubscriber.title"),
                              message: localized("alert.notSubscriber.message"),
                              actions: alertOk),
                     animated: true,
                     completion: nil
        )
    }
    
    public func showRestoredAlert(completion: (() -> ())? = nil) {
        let alertOk = UIAlertAction(title: localized("alert.action.ok"), style: .default) { _ in
            completion?() ?? ()
        }
        self.present(getAlert(title: localized("alert.restored.title"),
                              message: localized("alert.restored.message"),
                              actions: alertOk),
                     animated: true,
                     completion: nil
        )
    }
    
    func showLoader() {
        let alert = UIAlertController(title: nil, message: localized("alert.loading.message"), preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func hideLoader(completion: (() -> Void)? = nil) {
        dismiss(animated: false, completion: completion)
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
