//
//  Created by Beakbig
//

#if BBPERMISSIONSKIT
import BBPermissionsKit
#endif

#if BBPERMISSIONS_LOCATION
import CoreLocation
import Combine

/// Location Permission Setting
///
/// ##### Frameworks
/// - CoreLocation.framework
///
/// ##### info.plist
/// - Privacy - Location Always and When In Use Usage Description
/// <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
/// - Privacy - Location When In Use Usage Description
/// <key>NSLocationWhenInUseUsageDescription</key>
///
/// ##### Signing & Capabilities
/// - Background Modes - Location updates
///
/// ##### 기타
/// 항상 허용은 시스템에서 판별하여 따로 띄워주는 권한이며,
/// 백그라운드에서 계속 위치 정보 수집이 이뤄진다면 시스템에서 자체적으로 띄워줌
///
public class BBPermissionLocation: BBPermissionBase, BBPermissionProtocol {
    var isAlways: Bool
    var locationManager: BBLocationManager = BBLocationManager()
    var cancellable = Set<AnyCancellable>()
    
    public init(isAlways: Bool) {
        self.isAlways = isAlways
        super.init()
    }
    
    public func status() -> BBPermissionStatus {
        return locationManager.convertStatus(status: CLLocationManager.authorizationStatus())
    }

    public func requestPermission(completion: @escaping (BBPermissionStatus) -> ()) {
#if DEBUG
        if isAlways {
            guard hasDescriptionKey(in: "NSLocationAlwaysAndWhenInUseUsageDescription").isEmpty == false else {
                return
            }
        } else {
            guard hasDescriptionKey(in: "NSLocationWhenInUseUsageDescription").isEmpty == false else {
                return
            }
        }
#endif
        locationManager.onLocationPermission.dropFirst().sink { status in
            self.cancellable.removeAll()
            completion(status)
        }.store(in: &cancellable)
        locationManager.requestPermission(isAlways)
    }
    
    public func accessDeniedMessage() -> String {
        return customNoAccessMessage ?? {
            if isAlways {
                return BBPermissionUtil.localizable(key: "NSLocationAlwaysAndWhenInUseUsageDescription")
            } else {
                return BBPermissionUtil.localizable(key: "NSLocationWhenInUseUsageDescription")
            }
        }()
    }
}

extension BBPermissionLocation {
    /// 위치 권한 설정
    class BBLocationManager: NSObject, CLLocationManagerDelegate {
        let onLocationPermission = PassthroughSubject<BBPermissionStatus, Never>()
        private var manager: CLLocationManager
        
        override init() {
            manager = CLLocationManager()
            super.init()
            manager.delegate = self
        }
        
        func convertStatus(status: CLAuthorizationStatus = .notDetermined) -> BBPermissionStatus {
            if status == .authorizedAlways {
                return .authorized
            } else if status == .authorizedWhenInUse {
                return .limitedAuthorized
            } else if status == .notDetermined {
                return .notDetermined
            } else {
                return .denied
            }
        }
        
        func requestPermission(_ isAlways: Bool) {
            DispatchQueue.main.async {
                isAlways ? self.manager.requestAlwaysAuthorization() : self.manager.requestWhenInUseAuthorization()
            }
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            if #available(iOS 14.0, *) {
                onLocationPermission.send(convertStatus(status: manager.authorizationStatus))
            } else {
                onLocationPermission.send(convertStatus(status: CLLocationManager.authorizationStatus()))
            }
        }
    }
}
#endif
