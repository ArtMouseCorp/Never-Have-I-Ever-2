import UIKit

let userDefaults = UserDefaults.standard

enum UDKeys {
    static let appLaunchCount: String           = "appLaunchCount"
    static let language: String                 = "language"
}

enum AmplitudeEvent {
    static let appStartedFirst: String          = "First App Start"
    static let appStarted: String               = "App Started"
}

public var safeAreaBottomInset: CGFloat {
    let window = UIApplication.shared.windows.first
    let bottomPadding = window!.safeAreaInsets.bottom
    return bottomPadding
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
