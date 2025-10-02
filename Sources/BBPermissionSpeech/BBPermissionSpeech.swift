//
//  Created by Beakbig
//

#if BBPERMISSIONSKIT
import BBPermissionsKit
#endif

#if BBPERMISSIONS_SPEECH
import Speech

/// Speech Permission Setting
///
/// ##### Framework
/// - Speech.framework
///
/// ##### info.plist
/// - Privacy - Speech Recognition Usage Description
/// - <key>NSSpeechRecognitionUsageDescription</key>
/// 
public class BBPermissionSpeech: BBPermissionBase, BBPermissionProtocol {
    public func status() -> BBPermissionStatus {
        let status = SFSpeechRecognizer.authorizationStatus()
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
        guard hasDescriptionKey(in: "NSSpeechRecognitionUsageDescription").isEmpty == false else {
            return
        }
#endif
        SFSpeechRecognizer.requestAuthorization { status in
            completion(status == .authorized ? .authorized : .denied)
        }
    }
    
    public func accessDeniedMessage() -> String {
        return customNoAccessMessage ?? BBPermissionUtil.localizable(key: "NSSpeechRecognitionUsageDescription")
    }
}
#endif
