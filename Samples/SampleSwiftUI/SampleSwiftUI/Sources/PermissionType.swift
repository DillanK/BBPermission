//
//  Created by Beakbig
//

import BBPermissionsKit
import BBPermissionSiri
import BBPermissionPhoto
import BBPermissionCamera
import BBPermissionHealth
import BBPermissionMotion
import BBPermissionSpeech
import BBPermissionCalendar
import BBPermissionContacts
import BBPermissionLocation
import BBPermissionReminder
import BBPermissionBluetooth
import BBPermissionMicrophone
import BBPermissionNotification
import BBPermissionAppleMusic
import BBPermissionAppTracking

enum PermissionType: CaseIterable {
    case photo
    case notification
    case microphone
    case reminder
    case health
    case contacts
    case camera
    case calendar
    case bluetooth
    case location
    case siri
    case appleMusic
    case motion
    case speech
    case appTracking
    
    func getTitle() -> String {
        switch self {
            case .photo:
                "사진 접근 권한"
            case .notification:
                "알림 접근 권한"
            case .microphone:
                "마이크 접근 권한"
            case .reminder:
                "미리알림 접근 권한"
            case .health:
                "건강 접근 권한"
            case .contacts:
                "연락처 접근 권한"
            case .camera:
                "카메라 접근 권한"
            case .calendar:
                "달력 접근 권한"
            case .bluetooth:
                "블루투스 접근 권한"
            case .location:
                "위치 접근 권한(선택)"
            case .siri:
                "Siri 접근 권한"
            case .appleMusic:
                "Apple Music 접근 권한"
            case .motion:
                "동작/피트니스 접근 권한"
            case .speech:
                "음성 인식 접근 권한"
            case .appTracking:
                "앱 추적 접근 권한"
        }
    }
    
    func makePermission() -> BBPermissionProtocol {
        switch self {
            case .photo:
                return BBPermissionPhoto()
            case .notification:
                return BBPermissionNotification()
            case .microphone:
                return BBPermissionMicrophone()
            case .reminder:
                return BBPermissionReminder()
            case .health:
                return BBPermissionHealth(readType: .workoutType(), writeType: .workoutType())
            case .contacts:
                return BBPermissionContacts()
            case .camera:
                return BBPermissionCamera()
            case .calendar:
                return BBPermissionCalendar(isFullAccess: true)
            case .bluetooth:
                return BBPermissionBluetooth()
            case .location:
                return BBPermissionLocation(isAlways: false)
            case .siri:
                return BBPermissionSiri()
            case .appleMusic:
                return BBPermissionAppleMusic()
            case .motion:
                return BBPermissionMotion()
            case .speech:
                return BBPermissionSpeech()
            case .appTracking:
                let tracking = BBPermissionAppTracking()
                tracking.customNoAccessMessage("너의 취향 알아가고 싶어! 맞춤 광고로 깜짝 놀라게 할게! 🕵️")
                return tracking
        }
    }
}
