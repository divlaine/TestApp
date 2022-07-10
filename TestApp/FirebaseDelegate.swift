import UIKit
import Firebase
import AudioToolbox
import AVFoundation

class FirebaseDelegate: NSObject {
    
    private var authStatusProvider: AuthStatusProvider
    private var deviceProvider: DeviceProvider
    private var isPlayingSound = false
    
    var canShowMessage: (() -> Bool)?
    
    init(providerFactory: ProviderFactory) {
        authStatusProvider = providerFactory.authStatusProvider
        deviceProvider = providerFactory.deviceProvider
        
        super.init()
        
        // MARK: add service plist to make it work
//        FirebaseApp.configure()
//        Messaging.messaging().delegate = self
//        UNUserNotificationCenter.current().delegate = self
//        
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { [weak self] (_, error) in
//            guard error == nil else {
//                self?.deviceProvider.fcm = FcmCredentials(token: "", state: TFcmState.failed)
//                return
//            }
//        }
//        
//        UIApplication.shared.registerForRemoteNotifications()
    }
}

// MARK: Firebase Delegate
extension FirebaseDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    
    func didReceiveRemoteNotification(_ userInfo: [AnyHashable : Any]) {
        let notification = FcmNotification(userInfo)
        switch notification.documentType {
        case TFcm.order: onOrder(notification)
        case TFcm.message: onMessage(notification)
        case TFcm.orderMessage: onOrderMessage(notification)
        default: onDefault(notification)
        }
    }
    
    func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
        deviceProvider.fcm = FcmCredentials(token: "", state: TFcmState.failed)
        makeApiDeviceSave()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Message was received in foreground
        if !isPlayingSound {
            isPlayingSound = true
            AudioServicesPlaySystemSound(SystemSoundID(1007))
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.isPlayingSound = false
            }
        }
        didReceiveRemoteNotification(notification.request.content.userInfo)
        // Dont need to show as a push message
        // completionHandler([.alert, .sound])
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        deviceProvider.fcm = FcmCredentials(token: fcmToken, state: TFcmState.ok)
        makeApiDeviceSave()
    }
}

// MARK: - Api
extension FirebaseDelegate {
    
    func makeApiDeviceSave() {
        deviceProvider.save()
    }
}

// MARK: - Notifications
extension FirebaseDelegate {
    
    private func onDefault(_ notification: FcmNotification) {
        // Showing alert
    }
    
    private func onMessage(_ notification: FcmNotification) {
        // Showing message
    }
    
    private func onOrder(_ notification: FcmNotification) {
        // Showing order alert
    }
    
    private func onOrderMessage(_ notification: FcmNotification) {
        // Showing Order message
    }
}
