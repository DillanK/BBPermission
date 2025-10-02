//
//  Created by Beakbig
//

#if BBPERMISSIONSKIT
import BBPermissionsKit
#endif

#if BBPERMISSIONS_BLUETOOTH
import CoreBluetooth
import Combine

/// Bluetooth Permission Setting
///
/// ##### Frameworks
/// - CoreBluetooth.framework
///
/// ##### info.plist
/// - Privacy - Bluetooth Always Usage Description
/// <key>NSBluetoothAlwaysUsageDescription</key>
/// - Privacy - Bluetooth Peripheral Usage Description
/// <key>NSBluetoothPeripheralUsageDescription</key>
/// 
/// ##### Signing & Capabilities
/// - Background Modes
/// : Acts as a Bluetooth LE accessory
/// : Uses Bluetooth LE accessories
///
public class BBPermissionBluetooth: BBPermissionBase, BBPermissionProtocol {
    private let manager: BBBluetoothManager = BBBluetoothManager()
    private var cancellable = Set<AnyCancellable>()
    
    public func status() -> BBPermissionStatus {
        var status: CBManagerAuthorization = .notDetermined
        if #available(iOS 13.1, *) {
            status = CBCentralManager.authorization
        } else {
            status = CBCentralManager().authorization
        }
        
        if status == .allowedAlways {
            return .authorized
        } else if status == .notDetermined {
            return .notDetermined
        } else {
            return .denied
        }
    }

    public func requestPermission(completion: @escaping (BBPermissionStatus) -> ()) {
#if DEBUG
        guard hasDescriptionKey(in: "NSBluetoothAlwaysUsageDescription").isEmpty == false else {
            return
        }
#endif
        manager.onBluetoothPermission.sink { authorization in
            completion(authorization == .allowedAlways ? .authorized : .denied)
            self.cancellable.removeAll()
        }.store(in: &cancellable)
        manager.requestPermission()
    }
    
    public func accessDeniedMessage() -> String {
        customNoAccessMessage ?? BBPermissionUtil.localizable(key: "NSBluetoothAlwaysUsageDescription")
    }
}

extension BBPermissionBluetooth {
    /// Bluetooth 권한 설정
    class BBBluetoothManager: NSObject, CBCentralManagerDelegate {
        let onBluetoothPermission = PassthroughSubject<CBManagerAuthorization, Never>()
        var manager: CBCentralManager?
        
        func requestPermission() {
            manager = CBCentralManager(delegate: self, queue: nil)
        }
        
        func centralManagerDidUpdateState(_ central: CBCentralManager) {
            if #available(iOS 13.1, *) {
                onBluetoothPermission.send(CBCentralManager.authorization)
            } else {
                onBluetoothPermission.send(CBCentralManager().authorization)
            }
            manager = nil
        }
    }
}
#endif
