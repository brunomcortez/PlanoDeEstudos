import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let center = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        center.delegate = self
        center.getNotificationSettings { (settings) in
            switch (settings.authorizationStatus) {
            case .authorized:
                print("OK")
            case .denied:
                print("denied")
            case .notDetermined:
                self.center.requestAuthorization(options: [.alert, .sound, .badge]) { (accepted, error) in
                    if accepted { print("accepted") }
                }
            case .provisional:
                print("provisional")
            @unknown default :
                break
            }
        }
        
        let confirmAction = UNNotificationAction(identifier: "Confirm", title: "Já estudei 👍🏻", options: [.foreground])
        let cancelAction = UNNotificationAction(identifier: "Cancel", title: "Cancelar", options: [])
        let category = UNNotificationCategory(
            identifier: "Lembrete",
            actions: [confirmAction, cancelAction],
            intentIdentifiers: [],
            options: [.customDismissAction])
        center.setNotificationCategories([category])
        
        return true
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let id = response.notification.request.identifier
        switch response.actionIdentifier {
        case "Confirm":
            print("Confirm")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "Confirmed"), object: nil, userInfo: ["id": id])
        case "Cancel":
            print("Cancel")
        case UNNotificationDismissActionIdentifier:
            print("Dismiss")
        case UNNotificationDefaultActionIdentifier:
            print("Tapped notification")
        default:
            print("default")
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
}
