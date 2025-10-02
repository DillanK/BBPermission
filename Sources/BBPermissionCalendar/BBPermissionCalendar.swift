//
//  Created by Beakbig
//

#if BBPERMISSIONSKIT
import BBPermissionsKit
#endif

#if BBPERMISSIONS_CALENDAR
import Foundation
import EventKit

/// Calendar Permission Setting
///
/// ##### Frameworks
/// - EventKit.framework
///
/// ##### info.plist
/// - Privacy - Calendars Full Access Usage Description
/// <key>NSCalendarsFullAccessUsageDescription</key>
/// - Privacy - Calendars Write Only Usage Description
/// <key>NSCalendarsWriteOnlyAccessUsageDescription</key>
///
public class BBPermissionCalendar: BBPermissionBase, BBPermissionProtocol {
    private var isFullAccess: Bool

    /// 달력 권한 요청
    /// - Parameters:
    ///   - isFullAccess: 전체 권한은 true, 쓰기 권한은 false
    public init(isFullAccess: Bool = true) {
        self.isFullAccess = isFullAccess
        super.init()
    }
    
    public func status() -> BBPermissionStatus {
        let status = EKEventStore.authorizationStatus(for: .event)

        if #available(iOS 17, *) {
            if status == .fullAccess {
                return .authorized
            } else if status == .writeOnly {
                return .limitedAuthorized
            }
        }
        
        if status == .notDetermined {
            return .notDetermined
        } else if status == .authorized {
            return .authorized
        } else {
            return .denied
        }
    }

    public func requestPermission(completion: @escaping (BBPermissionStatus) -> ()) {
#if DEBUG
        if isFullAccess {
            guard hasDescriptionKey(in: "NSCalendarsFullAccessUsageDescription").isEmpty == false else {
                return
            }
        } else {
            guard hasDescriptionKey(in: "NSCalendarsWriteOnlyAccessUsageDescription").isEmpty == false else {
                return
            }
        }
#endif
        if #available(iOS 17, *) {
            if isFullAccess {
                EKEventStore().requestFullAccessToEvents { isGranted, error in
                    self.processAuthorizationResult(isGranted, error, completion)
                }
            } else {
                EKEventStore().requestWriteOnlyAccessToEvents { isGranted, error in
                    self.processAuthorizationResult(isGranted, error, completion)
                }
            }
        } else {
            EKEventStore().requestAccess(to: .event) { isGranted, error in
                self.processAuthorizationResult(isGranted, error, completion)
            }
        }
    }

    public func accessDeniedMessage() -> String {
        return customNoAccessMessage ?? {
            if isFullAccess {
                return BBPermissionUtil.localizable(key: "NSCalendarsFullAccessUsageDescription")
            } else {
                return BBPermissionUtil.localizable(key: "NSCalendarsWriteOnlyAccessUsageDescription")
            }
        }()
    }
}

extension BBPermissionCalendar {
    /// 권한 요청 결과 값 처리
    /// - Parameters:
    ///   - isGranted: 권한 허용 여부
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
        
        completion(isGranted ? (isFullAccess ? .authorized : .limitedAuthorized) : .denied)
    }
}
#endif
