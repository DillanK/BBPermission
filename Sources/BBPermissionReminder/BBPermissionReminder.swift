//
//  Created by Beakbig
//

#if BBPERMISSIONSKIT
import BBPermissionsKit
#endif

#if BBPERMISSIONS_REMINDER
import Foundation
import EventKit

/// Reminder Permission Setting
///
/// ##### Frameworks
/// - EventKit.framework
///
/// ##### info.plist
/// - Privacy - Reminders Full Access Usage Description (available : iOS 17)
/// - <key>NSRemindersFullAccessUsageDescription</key>
/// - Privacy - Reminders Usage Description
/// - <key>NSRemindersUsageDescription</key>
/// 
public class BBPermissionReminder: BBPermissionBase, BBPermissionProtocol {
    public func status() -> BBPermissionStatus {
        let status = EKEventStore.authorizationStatus(for: .reminder)

        if #available(iOS 17, *) {
            if status == .fullAccess {
                return .authorized
            }
        }
        
        if status == .notDetermined {
            return .notDetermined
        } else if status == .denied || status == .restricted {
            return .denied
        } else {
            return .authorized
        }
    }

    public func requestPermission(completion: @escaping (BBPermissionStatus) -> ()) {
#if DEBUG
        if #available(iOS 17, *) {
            guard hasDescriptionKey(in: "NSRemindersFullAccessUsageDescription").isEmpty == false else {
                return
            }
        } else {
            guard hasDescriptionKey(in: "NSRemindersUsageDescription").isEmpty == false else {
                return
            }
        }
#endif
        if #available(iOS 17, *) {
            EKEventStore().requestFullAccessToReminders { isGranted, error in
                self.processAuthorizationResult(isGranted, error, completion)
            }
        } else {
            EKEventStore().requestAccess(to: .reminder) { isGranted, error in
                self.processAuthorizationResult(isGranted, error, completion)
            }
        }
    }
    
    public func accessDeniedMessage() -> String {
        return customNoAccessMessage ?? {
            if #available(iOS 17, *) {
                return BBPermissionUtil.localizable(key: "NSRemindersFullAccessUsageDescription")
            } else {
                return BBPermissionUtil.localizable(key: "NSRemindersUsageDescription")
            }
        }()
    }
}

extension BBPermissionReminder {
    /// 권한 요청 결과 값 처리
    /// - Parameters:
    ///   - isAuthorized: 권한 허용 여부
    ///   - error: 에러 값
    ///   - completion: 결과 값 반환
    private func processAuthorizationResult(_ isGranted: Bool,
                                            _ error: (any Error)?,
                                            _ completion: @escaping (BBPermissionStatus) -> ()) {
        guard error == nil else {
            debugPrint(#file, #function, "Error Description : \(String(describing: error?.localizedDescription))")
            completion(.denied)
            return
        }
        
        completion(isGranted ? .authorized : .denied)
    }
}
#endif
