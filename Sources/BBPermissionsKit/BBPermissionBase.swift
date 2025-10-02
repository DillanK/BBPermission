//
//  BBPermissionBase.swift
//  BBPermission
//
//  Created by hyunjin on 9/17/25.
//

import Foundation
import UIKit

open class BBPermissionBase {
    public var customNoAccessMessage: String?
    
    public init() { }
    
    public func customNoAccessMessage(_ message: String) {
        self.customNoAccessMessage = message
    }
    
    public func hasDescriptionKey(in plistName: String) -> String {
        if let descriptionMessage = Bundle.main.object(forInfoDictionaryKey: plistName) as? String {
            return descriptionMessage
        }
#if DEBUG
        guard let vcRoot = BBPermissionUtil.rootViewController() else {
            return ""
        }
        
        let vcAlert = UIAlertController(title: BBPermissionUtil.localizable(key: "alertTitle"),
                                        message: "\(plistName)\(BBPermissionUtil.localizable(key: "unknownPlistDescription"))",
                                        preferredStyle: .alert)
        vcAlert.addAction(.init(title: BBPermissionUtil.localizable(key: "alertButtonCancel"), style: .cancel, handler: nil))
        vcRoot.present(vcAlert, animated: true)
        
        return ""
#else
        return ""
#endif
    }
}
