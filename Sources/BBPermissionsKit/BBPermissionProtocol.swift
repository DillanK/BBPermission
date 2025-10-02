//
//  Created by Beakbig
//
// #### 위치 권한 설정 시 필요 정보
// 

import Foundation
import UIKit

public protocol BBPermissionProtocol {
    func status() -> BBPermissionStatus
    func requestPermission(completion: @escaping (BBPermissionStatus) -> ()) // 권한별 요청 로직
    func accessDeniedMessage() -> String
    func requestPermission(with deniedMessage: Bool, completed: @escaping (BBPermissionStatus) -> ())
}

extension BBPermissionProtocol {
    public func requestPermission(with deniedMessage: Bool, completed: @escaping (BBPermissionStatus) -> ()) {
        let status = status()
        if status == .authorized || status == .limitedAuthorized {
            completed(status)
        } else if status == .notDetermined {
            requestPermission { status in
                if deniedMessage {
                    self.showDeniedPermissionDialog { isGoSetting in
                        completed(isGoSetting ? .deniedAndNeedsSettings : .denied)
                    }
                } else {
                    completed((status == .authorized || status == .limitedAuthorized) ? status : .denied)
                }
            }
        } else {
            self.showDeniedPermissionDialog { isGoSetting in
                completed(isGoSetting ? .deniedAndNeedsSettings : .denied)
            }
        }
    }
}

extension BBPermissionProtocol {
    private func settingURL() -> URL? {
        URL(string: UIApplication.openSettingsURLString)
    }
    
    private func showDeniedPermissionDialog(completed: @escaping (Bool) -> ()) {
        guard let vcRoot = BBPermissionUtil.rootViewController() else {
            completed(false)
            return
        }
 
        DispatchQueue.main.async {
            let vcAlert = UIAlertController(title: BBPermissionUtil.localizable(key: "alertTitle"),
                                            message: accessDeniedMessage(),
                                            preferredStyle: .alert)
            vcAlert.addAction(.init(title: BBPermissionUtil.localizable(key: "alertButtonCancel"),
                                    style: .cancel,
                                    handler: { action in
                completed(false)
            }))
            vcAlert.addAction(.init(title: BBPermissionUtil.localizable(key: "alertButtonSetting"),
                                    style: .destructive,
                                    handler: { action in
                guard let validUrl = settingURL() else {
                    completed(false)
                    return
                }
                UIApplication.shared.open(validUrl)
                completed(true)
            }))
            vcRoot.present(vcAlert, animated: true)
        }
    }
}
