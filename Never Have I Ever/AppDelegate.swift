import UIKit
import CoreData
import Firebase
import FirebaseMessaging
import FirebaseAnalytics
import Amplitude
import ApphudSDK
import StoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var orientationLock: UIInterfaceOrientationMask = .portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        State.shared.newAppLaunch()
        
        // Services connection
        integrateFirebase()
        integrateAmplitude()
        integrateApphud()
        integrateNotifications(for: application)
        
        return true
    }
    
    // MARK: - Services integration functions
    
    private func integrateFirebase() {
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
    }
    
    private func integrateAmplitude() {
        // Enable sending automatic session events
        Amplitude.instance().trackingSessionEvents = true
        // Initialize SDK
        Amplitude.instance().initializeApiKey(Config.AMPLITUDE_API_KEY)
        // Log an event
        Amplitude.instance().logEvent("App started")
    }
    
    private func integrateApphud() {
        Apphud.enableDebugLogs()
        Apphud.start(apiKey: Config.APPHUD_API_KEY)
    }
    
    private func integrateNotifications(for application: UIApplication) {
        // 1
        UNUserNotificationCenter.current().delegate = self
        // 2
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions) { _, _ in }
        // 3
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
    }
    
    // MARK: - UISceneSession Lifecycle
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Never Have I Ever")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        process(notification)
        if #available(iOS 14.0, *) {
            completionHandler([[.banner, .sound]])
        } else {
            completionHandler([[.alert, .sound]])
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        process(response.notification)
        
        let notificationId = response.notification.request.identifier
        
        if notificationId == "ChristmasNotificationID" {
            State.openChristmasSceen = true
            
            let loadNC = UINavigationController.load(from: Main.homeNav)
            loadNC.modalPresentationStyle = .fullScreen
            topController().present(loadNC, animated: false)
            
        } else {
            State.openChristmasSceen = false
        }
        
        completionHandler()
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("NOTIFICATIONS ERROR - \(error)")
    }
    
    private func process(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        Analytics.logEvent("NOTIFICATION_PROCESSED", parameters: nil)
    }
    
}

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let tokenDict = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: tokenDict)
        
        subscribeToNotificationsTopic("NeverHaveIEver2All")
        
        if let regionCode = Locale.current.regionCode {
            
            switch regionCode {
                
            case "US", "AU", "CA", "NZ":    subscribeToNotificationsTopic("US_AU_CA_NZ")
            case "GB":                      subscribeToNotificationsTopic("GB")
            case "RU":                      subscribeToNotificationsTopic("RU")
            case "DE":                      subscribeToNotificationsTopic("DE")
            default:                        break
            }
            
            Analytics.setUserProperty(regionCode, forName: "regionCode")
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
