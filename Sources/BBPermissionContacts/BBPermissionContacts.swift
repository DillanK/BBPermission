//
//  Created by Beakbig
//

#if BBPERMISSIONSKIT
import BBPermissionsKit
#endif

#if BBPERMISSIONS_CONTACTS
import Contacts

/// Contact Permission Setting
///
/// ##### Frameworks
/// - Contacts.framework
///
/// ##### info.plist
/// - Privacy - Contacts Usage Description
/// <key>NSContactsUsageDescription</key>
///
public class BBPermissionContacts: BBPermissionBase, BBPermissionProtocol {
    public func status() -> BBPermissionStatus {
        let status = CNContactStore.authorizationStatus(for: .contacts)

        if #available(iOS 18, *), status == .limited {
            return .limitedAuthorized
        }
        
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
        guard hasDescriptionKey(in: "NSContactsUsageDescription").isEmpty == false else {
            return
        }
#endif
        CNContactStore().requestAccess(for: .contacts) { isGranted, error in
            completion(isGranted ? .authorized : .denied)
        }
    }
    
    public func accessDeniedMessage() -> String {
        return customNoAccessMessage ?? BBPermissionUtil.localizable(key: "NSContactsUsageDescription")
    }
}
#endif
