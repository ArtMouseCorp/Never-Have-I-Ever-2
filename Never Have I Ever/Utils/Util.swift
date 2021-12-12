import UIKit
import SystemConfiguration
import FirebaseMessaging

public func readLocalJSONFile(forName name: String) -> Data? {
    do {
        if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
            let fileUrl = URL(fileURLWithPath: filePath)
            let data = try Data(contentsOf: fileUrl)
            return data
        }
    } catch {
        print("error: \(error)")
    }
    return nil
}

func getNoun(number: Int, one: String, two: String, five: String) -> String {
    var n = abs(number)
    n %= 100
    if (n >= 5 && n <= 20) {
        return five
    }
    n %= 10
    if (n == 1) {
        return one
    }
    if (n >= 2 && n <= 4) {
        return two
    }
    return five
}

public func getAlert(title: String?, message: String? = nil, actions: UIAlertAction...) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    actions.forEach { action in
        alert.addAction(action)
    }
    return alert
}

public func isConnectedToNetwork() -> Bool {
    
    var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
    if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
        return false
    }
    
    // Working for Cellular and WIFI
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    let ret = (isReachable && !needsConnection)
    
    return ret
    
}

public func topController() -> UIViewController {
    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    
    var topController = keyWindow?.rootViewController!
    while let presentedViewController = topController?.presentedViewController {
        topController = presentedViewController
    }
    return topController!
}

public func localized(_ key: String) -> String {
    let path = Bundle.main.path(forResource: State.shared.getLanguageCode().rawValue, ofType: "lproj")
    let bundle = Bundle(path: path!) ?? Bundle.main
    let format = bundle.localizedString(forKey: key, value: nil, table: nil)
    return String(format: format)
}

public func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    if let delegate = UIApplication.shared.delegate as? AppDelegate {
        delegate.orientationLock = orientation
    }
}

public func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
    lockOrientation(orientation)
    UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
}

public func subscribeToNotificationsTopic(_ topic: String) {
    Messaging.messaging().subscribe(toTopic: topic) { error in
        
        if let error = error {
            print("ERROR | Subscription to '\(topic)' notifications topic has failed - \(error.localizedDescription)")
        }
        
        print("SUCCESS | Successfully subscribed to '\(topic)' notifications topic")
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
