//
//  Created by Beakbig
//

#if BBPERMISSIONSKIT
import BBPermissionsKit
#endif

#if BBPERMISSIONS_APPLEMUSIC
import Foundation
import MediaPlayer

/// AppleMusic Permission Setting
///
/// ##### Frameworks
/// - MediaPlayer.framework
///
/// ##### info.plist
/// - Privacy - Media Library Usage Description
/// <key>NSAppleMusicUsageDescription</key>
///
public class BBPermissionAppleMusic: BBPermissionBase, BBPermissionProtocol {
    public func status() -> BBPermissionStatus {
        let status = MPMediaLibrary.authorizationStatus()
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
        guard hasDescriptionKey(in: "NSAppleMusicUsageDescription").isEmpty == false else {
            return
        }
#endif
        MPMediaLibrary.requestAuthorization { status in
            completion(status == .authorized ? .authorized : .denied)
        }
    }
    
    public func accessDeniedMessage() -> String {
        return customNoAccessMessage ?? BBPermissionUtil.localizable(key: "NSAppleMusicUsageDescription")
    }
}
#endif
