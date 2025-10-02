//
//  BBPermissionUtil.swift
//  BBPermissionsKit
//
//  Created by hyunjin on 10/2/25.
//

import UIKit
import Foundation

public class BBPermissionUtil {
    static func rootViewController() -> UIViewController? {
        if let window = UIApplication.shared.windows.first, let vcRoot = window.rootViewController {
            return vcRoot
        } else if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first,
                let vcRoot = window.rootViewController {
            return vcRoot
        }
        
        return nil
    }
    
    public static func localizable(key: String) -> String {
        let mainBundleLocalString = NSLocalizedString(key, tableName: "Localizable", bundle: .main, comment: "")
        guard mainBundleLocalString == key else {
            return mainBundleLocalString
        }
        return NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: "")
    }
}
