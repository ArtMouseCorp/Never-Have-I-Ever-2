import UIKit

public enum Popup: String, StoryboardScreen {
    
    case level          = "LevelPopup"
    case customTasks    = "CustomTasksPopup"
    case customTask     = "CustomTaskPopup"
    case quit           = "QuitPopup"
    case image          = "ImagePopup"
    case demoImage      = "DemoImagePopup"
}

extension Popup {
    
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
