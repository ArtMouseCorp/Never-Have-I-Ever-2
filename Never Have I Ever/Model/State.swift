import Foundation

class State {
    
    // MARK: - Variables
    
    // Shared variable
    
    public static var shared: State = State()
    public static var openChristmasSceen: Bool = false
    
    // State properties
    
    private var appLaunch: Int = 0
    public var isSubscribed: Bool = false
    
    public var subscriptionConfig: SubscriptionConfig = .default
    
    public var selectedLevels: [Level] = []
    public var customTasks: [String] = []
    
    // MARK: - Functions
    
    public func newAppLaunch() {
        self.appLaunch = self.getAppLaunchCount() + 1
        userDefaults.set(self.appLaunch, forKey: UDKeys.appLaunchCount)
    }
    
    public func getAppLaunchCount() -> Int {
        self.appLaunch = userDefaults.integer(forKey: UDKeys.appLaunchCount)
        return self.appLaunch
    }
    
    public func isFirstLaunch() -> Bool {
        return self.appLaunch == 1
    }
    
    // MARK: - Language
    
    public func getLanguageCode() -> Language.Code {
        let code = userDefaults.string(forKey: UDKeys.language) ?? "en"
        return Language.Code.init(code)
    }
    
    public func setLanguage(to languageCode: Language.Code) {
        userDefaults.set(languageCode.rawValue, forKey: UDKeys.language)
        
        SubscriptionConfig.get()
        Level.get()
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
