//
//  Created by Beakbig
//
#if BBPERMISSIONSKIT
import BBPermissionsKit
#endif

#if BBPERMISSIONS_CAMERA
import AVFoundation

/// Camera Permission Setting
///
/// ##### Frameworks
/// - AVFoundation.framework
///
/// ##### info.plist
/// - Privacy - Camera Usage Description
/// <key>NSCameraUsageDescription</key>
///
public class BBPermissionCamera: BBPermissionBase, BBPermissionProtocol {
    public func status() -> BBPermissionStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
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
        guard hasDescriptionKey(in: "NSCameraUsageDescription").isEmpty == false else {
            return
        }
#endif
        AVCaptureDevice.requestAccess(for: .video) { isGranted in
            completion(isGranted ? .authorized : .denied)
        }
    }
    
    public func accessDeniedMessage() -> String {
        customNoAccessMessage ?? BBPermissionUtil.localizable(key: "NSCameraUsageDescription")
    }
}
#endif
