//
//  Created by Beakbig
//

#if BBPERMISSIONSKIT
import BBPermissionsKit
#endif

#if BBPERMISSIONS_SIRI
import Intents

/// Siri Permission Setting
///
/// ##### Frameworks
/// - Intents.framework
///
/// ##### info.plist
/// - Privacy - Siri Usage Description
/// - <key>NSSiriUsageDescription</key>
/// 
/// ##### Signing & Capabilities
/// - Siri
/// 
public class BBPermissionSiri: BBPermissionBase, BBPermissionProtocol {
    public func status() -> BBPermissionStatus {
        let status = INPreferences.siriAuthorizationStatus()
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
        guard hasDescriptionKey(in: "NSSiriUsageDescription").isEmpty == false else {
            return
        }
#endif
        INPreferences.requestSiriAuthorization { status in
            completion(status == .authorized ? .authorized : .denied)
        }
    }
    
    public func accessDeniedMessage() -> String {
        return customNoAccessMessage ?? BBPermissionUtil.localizable(key: "NSSiriUsageDescription")
    }
}
#endif
