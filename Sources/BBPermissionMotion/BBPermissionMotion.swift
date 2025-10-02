//
//  Created by Beakbig
//

#if BBPERMISSIONSKIT
import BBPermissionsKit
#endif

#if BBPERMISSIONS_MOTION
import CoreMotion
import Combine

/// Motion Permission Setting
///
/// ##### Frameworks
/// - CoreMotion.framework
///
/// ##### info.plist
/// - Privacy - Motion Usage Description
/// <key>NSMotionUsageDescription</key>
///
public class BBPermissionMotion: BBPermissionBase, BBPermissionProtocol {
    private var cancellables = Set<AnyCancellable>()
    
    public func status() -> BBPermissionStatus {
        let status = CMMotionActivityManager.authorizationStatus()
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
        guard hasDescriptionKey(in: "NSMotionUsageDescription").isEmpty == false else {
            return
        }
#endif
        // CMMotionActivityManager 는 거부 시 거부에 관련된 이벤트를 주지 않음
        // 그래서 주기적으로 체크해서 Callback 처리
        let storeRequestStatus = CMMotionActivityManager.authorizationStatus()
        Timer.TimerPublisher(interval: 0.1, runLoop: .main, mode: .common)
                    .autoconnect()
                    .sink { [weak self] _ in
                        guard let self = self else { return }
                        if storeRequestStatus != CMMotionActivityManager.authorizationStatus() {
                            self.cancellables.removeAll()
                            completion(self.status())
                        }
                    }
                    .store(in: &cancellables)
        
        let manager = CMMotionActivityManager()
        manager.startActivityUpdates(to: .main) { _ in
            manager.stopActivityUpdates()
        }
    }
    
    public func accessDeniedMessage() -> String {
        return customNoAccessMessage ?? BBPermissionUtil.localizable(key: "NSMotionUsageDescription")
    }
}
#endif
