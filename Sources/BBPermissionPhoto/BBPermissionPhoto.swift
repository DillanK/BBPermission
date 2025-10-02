//
//  Created by Beakbig
//

#if BBPERMISSIONSKIT
import BBPermissionsKit
#endif

#if BBPERMISSIONS_PHOTOS
import Photos

/// Photo Permission Setting
///
/// ##### Frameworks
/// - Photos.framework
///
/// ##### info.plist
/// - Privacy - Photo Library Usage Description
/// - <key>NSPhotoLibraryUsageDescription</key>
/// - Privacy - Photo Library Additions Usage Description
/// - <key>NSPhotoLibraryAddUsageDescription</key>
/// 
public class BBPermissionPhoto: BBPermissionBase, BBPermissionProtocol {
    private var accessLevel: PhotoAccessLevel

    public init(accessLevel: PhotoAccessLevel = .readWrite) {
        self.accessLevel = accessLevel
        super.init()
    }
    
    public func status() -> BBPermissionStatus {
        if #available(iOS 14, *) {
            let status = PHPhotoLibrary.authorizationStatus(for: accessLevel.convertPHAccessLevel())
            if status == .authorized {
                return .authorized
            } else if status == .limited {
                return.limitedAuthorized
            } else if status == .notDetermined {
                return .notDetermined
            } else {
                return .denied
            }
        } else {
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .authorized {
                return .authorized
            } else if status == .notDetermined {
                return .notDetermined
            } else {
                return .denied
            }
        }
    }

    public func requestPermission(completion: @escaping (BBPermissionStatus) -> ()) {
#if DEBUG
        if accessLevel == .readWrite {
            guard hasDescriptionKey(in: "NSPhotoLibraryUsageDescription").isEmpty == false else {
                return
            }
        } else {
            guard hasDescriptionKey(in: "NSPhotoLibraryAddUsageDescription").isEmpty == false else {
                return
            }
        }
#endif
        PHPhotoLibrary.requestAuthorization { status in
            if #available(iOS 14, *), status == .limited {
                completion(.limitedAuthorized)
            } else if status == .authorized {
                completion(.authorized)
            } else {
                completion(.denied)
            }
        }
    }
    
    public func accessDeniedMessage() -> String {
        return customNoAccessMessage ?? {
            if accessLevel == .readWrite {
                return BBPermissionUtil.localizable(key: "NSPhotoLibraryUsageDescription")
            } else {
                return BBPermissionUtil.localizable(key: "NSPhotoLibraryAddUsageDescription")
            }
        }()
    }
}

public enum PhotoAccessLevel: Int {
    case addOnly = 1
    case readWrite = 2
    
    @available(iOS 14, *)
    public func convertPHAccessLevel() -> PHAccessLevel {
        return PHAccessLevel(rawValue: self.rawValue)!
    }
}
#endif
