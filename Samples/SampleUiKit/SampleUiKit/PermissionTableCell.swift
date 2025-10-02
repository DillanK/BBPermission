//
//  PermissionTableCell.swift
//  BBPermission
//
//  Created by hyunjin on 9/12/25.
//

import UIKit
import BBPermissionsKit

class PermissionTableCell: UITableViewCell {
    @IBOutlet var lblPermissionName: UILabel!
    @IBOutlet var lblPermissionState: UILabel!
    
    var type: PermissionType? = nil
    var permission: BBPermissionProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(type: PermissionType) {
        self.type = type
        self.permission = self.type?.makePermission()
    }
    
    func loadView() {
        lblPermissionName.text = type?.getTitle() ?? "Permission Type이 설정되어있지 않음"
        let permissionStatus: (text: String, color: UIColor) = {
            switch permission?.status() {
                case .authorized:
                    return ("승인", UIColor(named: "AuthrizedText")!)
                case .denied:
                    return ("거부", UIColor(named: "DeniedText")!)
                case .notDetermined:
                    return ("요청 필요", UIColor(named: "DeterminedText")!)
                case .limitedAuthorized:
                    return ("제한된 권한", UIColor(named: "LimitAuthrizedText")!)
                default:
                    return ("", .white)
            }
        }()
        
        let defaultText = "권한 상태 : "
        let attributedString = NSMutableAttributedString(string: "\(defaultText)\(permissionStatus.text)")
        let range = NSRange(location: defaultText.count, length: permissionStatus.text.count)
        attributedString.addAttribute(.foregroundColor, value: permissionStatus.color, range: range)
        lblPermissionState.attributedText = attributedString
    }
}
