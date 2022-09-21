import UIKit

struct NotificationIdentifiers {
    static let confirm = "Confirm"
    static let cancel = "Cancel"
    static let category = "Lembrete"
    static let confirmed = "Confirmed"
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
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Errou ao tentar se registrar ao serviço de push notification: ", error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("O app foi registrado para receber push notifications")
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        print("Aqui está o seu token: ", token)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
                    
        switch response.actionIdentifier {
        case NotificationIdentifiers.confirm:
            print("Usuário apertou botão de confirmar")
            let id = response.notification.request.identifier
            
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: NotificationIdentifiers.confirmed),
                object: nil,
                userInfo: ["id":id]
            )
            
            
        case NotificationIdentifiers.cancel:
            print("Usuário apertou botão de cancelar")
        case UNNotificationDefaultActionIdentifier:
            print("Usuário apertou na notificação")
        case UNNotificationDismissActionIdentifier:
            print("Usuário deu dismiss na notificação")
        default:
            print("Outra ação na notificação")
        }
        
        completionHandler()
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.banner, .sound])
    }
}
