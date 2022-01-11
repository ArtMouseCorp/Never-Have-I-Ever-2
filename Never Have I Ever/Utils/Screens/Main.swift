import UIKit

public enum Main: String, StoryboardScreen {
        
    case tabBar         = "TabBarController"
    case loading        = "LoadingViewController"
    case homeNav        = "HomeNavigationController"
    case home           = "HomeViewController"
    case setting        = "SettingsViewConrtoller"
    case manual         = "ManualViewConrtoller"
    case game           = "GameViewController"
    case gameover       = "GameOverViewController"
    case subscription   = "SubscriptionViewController"
    case christmas      = "ChristmasViewController"
    case jokes          = "JokesViewController"
    case progress       = "ProgressViewController"
    case joke           = "JokeViewController"
}

extension Main {
    
    public var location: Storyboard { return .Main }
    public var id: String { return self.rawValue }
    public var storyboard: UIStoryboard {
        return UIStoryboard(name: self.location.rawValue, bundle: nil)
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
