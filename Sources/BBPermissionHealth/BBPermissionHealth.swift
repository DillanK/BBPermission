//
//  Created by Beakbig
//

#if BBPERMISSIONSKIT
import BBPermissionsKit
#endif

#if BBPERMISSIONS_HEALTH
import HealthKit

/// Health Permission Setting
///
/// ##### Frameworks
/// - HealthKit.framework
///
/// ##### info.plist
/// - Privacy - Health Share Usage Description
/// <key>NSHealthShareUsageDescription</key>
/// - Privacy - Health Update Usage Description
/// <key>NSHealthUpdateUsageDescription</key>
///
/// ##### Signing & Capabilities
/// - HealthKit
///
public class BBPermissionHealth: BBPermissionBase, BBPermissionProtocol {
    private var readTypes: Set<HKObjectType>
    private var writeTypes: Set<HKSampleType>

    /// 달력 권한 요청
    /// - Parameters:
    ///   - customNoAccessMessage: 권한 없는 경우 표시 할 메시지
    ///   - type: 요청할 권한
    public init(readTypes: Set<HKObjectType>, writeTypes: Set<HKSampleType>) {
        self.readTypes = readTypes
        self.writeTypes = writeTypes
        super.init()
    }
    
    public func status() -> BBPermissionStatus {
        var finalStatus: BBPermissionStatus = .denied
        let semaphore = DispatchSemaphore(value: 0) // 스레드 동기화를 위한 세마포어

        HKHealthStore().getRequestStatusForAuthorization(toShare: writeTypes, read: readTypes) { status, error in
            if error == nil {
                if status == .shouldRequest {
                    finalStatus = .notDetermined
                } else if status == .unnecessary {
                    finalStatus = .authorized
                } else {
                    finalStatus = .denied
                }
            }
            
            semaphore.signal()
        }
        semaphore.wait()
        return finalStatus
    }

    public func requestPermission(completion: @escaping (BBPermissionStatus) -> ()) {
#if DEBUG
        guard hasDescriptionKey(in: "NSHealthShareUsageDescription").isEmpty == false else {
            return
        }
#endif
        HKHealthStore().requestAuthorization(toShare: writeTypes,
                                             read: readTypes) { isGranted, error in
            guard error == nil else {
                debugPrint(#file, #function, "Error Description : \(String(describing: error?.localizedDescription))")
                completion(.denied)
                return
            }
            
            completion(isGranted ? .authorized : .denied)
        }
    }
    
    public func accessDeniedMessage() -> String {
        return customNoAccessMessage ?? BBPermissionUtil.localizable(key: "NSHealthShareUsageDescription")
    }
}
#endif
