//
//  Created by Beakbig
//
#if BBPERMISSIONSKIT
import BBPermissionsKit
#endif

#if BBPERMISSIONS_APPTRACKING
import Foundation
import AppTrackingTransparency

/// AppTracking Permission Setting
///
/// ##### Frameworks
/// - AppTrackingTransparency.framework
///
/// ##### info.plist
/// - Privacy - Tracking Usage Description
/// <key>NSUserTrackingUsageDescription</key>
///
@available(iOS 14, *)
public class BBPermissionAppTracking: BBPermissionBase, BBPermissionProtocol {
    public func status() -> BBPermissionStatus {
        let status = ATTrackingManager.trackingAuthorizationStatus
        if status == .authorized {
            return .authorized
        } else if status == .notDetermined {
            return .notDetermined
        } else {
            return .denied
        }
    }

    public func requestPermission(completion: @escaping (BBPermissionStatus) -> ()) {
#if DEBUG
        guard hasDescriptionKey(in: "NSUserTrackingUsageDescription").isEmpty == false else {
            return
        }
#endif
        ATTrackingManager.requestTrackingAuthorization { status in
            completion(status == .authorized ? .authorized : .denied)
        }
    }
    
    public func accessDeniedMessage() -> String {
        return customNoAccessMessage ?? BBPermissionUtil.localizable(key: "NSUserTrackingUsageDescription")
    }
}
#endif
