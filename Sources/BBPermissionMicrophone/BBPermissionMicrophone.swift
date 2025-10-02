//
//  Created by Beakbig
//

#if BBPERMISSIONSKIT
import BBPermissionsKit
#endif

#if BBPERMISSIONS_MICROPHONE
import AVFAudio

/// Microphone Permission Setting
///
/// ##### Frameworks
/// - AVFAudio.framework
///
/// ##### info.plist
/// - Privacy - Microphone Usage Description
/// <key>NSMicrophoneUsageDescription</key>
///
public class BBPermissionMicrophone: BBPermissionBase, BBPermissionProtocol {
    public func status() -> BBPermissionStatus {
        if #available(iOS 17.0, *) {
            let status = AVAudioApplication.shared.recordPermission
            if status == .granted {
                return .authorized
            } else if status == .undetermined {
                return .notDetermined
            } else {
                return .denied
            }
        } else {
            let status = AVAudioSession.sharedInstance().recordPermission
            if status == .granted {
                return .authorized
            } else if status == .undetermined {
                return .notDetermined
            } else {
                return .denied
            }
        }
    }

    public func requestPermission(completion: @escaping (BBPermissionStatus) -> ()) {
#if DEBUG
        guard hasDescriptionKey(in: "NSMicrophoneUsageDescription").isEmpty == false else {
            return
        }
#endif
        if #available(iOS 17, *) {
            AVAudioApplication.requestRecordPermission { isGranted in
                completion(isGranted ? .authorized : .denied)
            }
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission { isGranted in
                completion(isGranted ? .authorized : .denied)
            }
        }
    }
    
    public func accessDeniedMessage() -> String {
        return customNoAccessMessage ?? BBPermissionUtil.localizable(key: "NSMicrophoneUsageDescription")
    }
}
#endif
