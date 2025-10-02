//
//  Created by Beakbig
//

#if BBPERMISSIONSKIT
import BBPermissionsKit
#endif

#if BBPERMISSIONS_NOTIFICATION
import UserNotifications
import UIKit

/// Notification Permission Setting
/// 
/// ##### Frameworks
/// - UserNotifications.framework
/// 
/// ##### Signing & Capabilities
/// - Push Notifications
/// 
public class BBPermissionNotification: BBPermissionBase, BBPermissionProtocol {
    public func status() -> BBPermissionStatus {
        var finalStatus: BBPermissionStatus = .notDetermined
        let semaphore = DispatchSemaphore(value: 0) // 스레드 동기화를 위한 세마포어

        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional, .ephemeral:
                finalStatus = .authorized
            case .notDetermined:
                finalStatus = .notDetermined
            default:
                finalStatus = .denied
            }
            semaphore.signal()
        }

        semaphore.wait()
        return finalStatus
    }

    public func requestPermission(completion: @escaping (BBPermissionStatus) -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { isGranted, error in
            if isGranted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            completion(isGranted ? .authorized : .denied)
        }
    }
    
    public func accessDeniedMessage() -> String {
        return customNoAccessMessage ?? BBPermissionUtil.localizable(key: "NSNotificationDescription")
    }
    
    /// Check Push Notification Enabled
    /// - Returns: Enable is true
    public func canShowNotification() async -> Bool {
        let isEnable: Bool = await UIApplication.shared.isRegisteredForRemoteNotifications
        if isEnable {
            return await {
                return Task {
                    let settings = await UNUserNotificationCenter.current().notificationSettings()
                    if settings.alertSetting == .enabled
                        || settings.lockScreenSetting == .enabled
                        || settings.notificationCenterSetting == .enabled {
                        return true
                    }
                    return false
                }
                
            }().result.get()
        }
        return false
    }
}
#endif
