import UIKit

public enum Storyboard: String {
    case LaunchScreen   = "LaunchScreen"
    case Main           = "Main"
}

public protocol StoryboardScreen {
    var id: String { get }
    var location: Storyboard { get }
    var storyboard: UIStoryboard { get }
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
