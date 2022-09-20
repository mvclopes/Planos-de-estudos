import UIKit

struct NotificationIdentifiers {
    static let confirm = "Confirm"
    static let cancel = "Cancel"
    static let category = "Lembrete"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let center = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        center.delegate = self
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.center.requestAuthorization(options: [.sound, .alert, .badge,  .carPlay]) { authorized, error in
                    print("O usuário autorizou?", authorized)
                }
            case .authorized:
                print("O usuário já aceitou. Show de bola!")
            default:
                print("Provavelmente o usuário aceitou. Vou bolar alguma estratégia!")
            }
        }
        
        let confirmAction = UNNotificationAction(
            identifier: NotificationIdentifiers.confirm,
            title: "Já estudei 👍🏻",
            options: [.foreground]
        )
        let cancelAction = UNNotificationAction(
            identifier: NotificationIdentifiers.cancel,
            title: "Cancelar",
            options: []
        )
        let category = UNNotificationCategory(
            identifier: NotificationIdentifiers.category,
            actions: [confirmAction, cancelAction],
            intentIdentifiers: []
        )
        
        center.setNotificationCategories([category])
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.banner, .sound])
    }
}
