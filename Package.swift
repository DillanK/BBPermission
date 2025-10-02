// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "BBPermissionsKit",
    defaultLocalization: "kr",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "BBPermissionsKit", targets: ["BBPermissionsKit"]),
        .library(name: "BBPermissionCamera", targets: ["BBPermissionCamera"]),
        .library(name: "BBPermissionLocation", targets: ["BBPermissionLocation"]),
        .library(name: "BBPermissionHealth", targets: ["BBPermissionHealth"]),
        .library(name: "BBPermissionMicrophone", targets: ["BBPermissionMicrophone"]),
        .library(name: "BBPermissionContacts", targets: ["BBPermissionContacts"]),
        .library(name: "BBPermissionAppleMusic", targets: ["BBPermissionAppleMusic"]),
        .library(name: "BBPermissionSpeech", targets: ["BBPermissionSpeech"]),
        .library(name: "BBPermissionCalendar", targets: ["BBPermissionCalendar"]),
        .library(name: "BBPermissionAppTracking", targets: ["BBPermissionAppTracking"]),
        .library(name: "BBPermissionBluetooth", targets: ["BBPermissionBluetooth"]),
        .library(name: "BBPermissionNotification", targets: ["BBPermissionNotification"]),
        .library(name: "BBPermissionReminder", targets: ["BBPermissionReminder"]),
        .library(name: "BBPermissionMotion", targets: ["BBPermissionMotion"]),
        .library(name: "BBPermissionSiri", targets: ["BBPermissionSiri"]),
        .library(name: "BBPermissionPhoto", targets: ["BBPermissionPhoto"])
    ],
    targets: [
        .target(
            name: "BBPermissionsKit",
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .define("BBPERMISSIONSKIT")
            ]
        ),
        .target(
            name: "BBPermissionCamera",
            dependencies: [.target(name: "BBPermissionsKit")],
            swiftSettings: [
                .define("BBPERMISSIONS_CAMERA"),
                .define("BBPERMISSIONSKIT")
            ],
            linkerSettings: [.linkedFramework("AVFoundation")]
        ),
        .target(
            name: "BBPermissionLocation",
            dependencies: [.target(name: "BBPermissionsKit")],
            path: "Sources/BBPermissionLocation",
            swiftSettings: [
                .define("BBPERMISSIONS_LOCATION"),
                .define("BBPERMISSIONSKIT")
            ],
            linkerSettings: [.linkedFramework("CoreLocation")]
        ),
        .target(
            name: "BBPermissionHealth",
            dependencies: [.target(name: "BBPermissionsKit")],
            path: "Sources/BBPermissionHealth",
            swiftSettings: [
                .define("BBPERMISSIONS_HEALTH"),
                .define("BBPERMISSIONSKIT")
            ],
            linkerSettings: [.linkedFramework("HealthKit")]
        ),
        .target(
            name: "BBPermissionMicrophone",
            dependencies: [.target(name: "BBPermissionsKit")],
            path: "Sources/BBPermissionMicrophone",
            swiftSettings: [
                .define("BBPERMISSIONS_MICROPHONE"),
                .define("BBPERMISSIONSKIT")
            ],
            linkerSettings: [.linkedFramework("AVFoundation")]
        ),
        .target(
            name: "BBPermissionContacts",
            dependencies: [.target(name: "BBPermissionsKit")],
            path: "Sources/BBPermissionContacts",
            swiftSettings: [
                .define("BBPERMISSIONS_CONTACTS"),
                .define("BBPERMISSIONSKIT")
            ],
            linkerSettings: [.linkedFramework("Contacts")]
        ),
        .target(
            name: "BBPermissionAppleMusic",
            dependencies: [.target(name: "BBPermissionsKit")],
            path: "Sources/BBPermissionAppleMusic",
            swiftSettings: [
                .define("BBPERMISSIONS_APPLEMUSIC"),
                .define("BBPERMISSIONSKIT")
            ],
            linkerSettings: [.linkedFramework("MediaPlayer")]
        ),
        .target(
            name: "BBPermissionSpeech",
            dependencies: [.target(name: "BBPermissionsKit")],
            path: "Sources/BBPermissionSpeech",
            swiftSettings: [
                .define("BBPERMISSIONS_SPEECH"),
                .define("BBPERMISSIONSKIT")
            ],
            linkerSettings: [.linkedFramework("Speech")]
        ),
        .target(
            name: "BBPermissionCalendar",
            dependencies: [.target(name: "BBPermissionsKit")],
            path: "Sources/BBPermissionCalendar",
            swiftSettings: [
                .define("BBPERMISSIONS_CALENDAR"),
                .define("BBPERMISSIONSKIT")
            ],
            linkerSettings: [.linkedFramework("EventKit")]
        ),
        .target(
            name: "BBPermissionAppTracking",
            dependencies: [.target(name: "BBPermissionsKit")],
            path: "Sources/BBPermissionAppTracking",
            swiftSettings: [
                .define("BBPERMISSIONS_APPTRACKING"),
                .define("BBPERMISSIONSKIT")
            ],
            linkerSettings: [.linkedFramework("AppTrackingTransparency")]
        ),
        .target(
            name: "BBPermissionBluetooth",
            dependencies: [.target(name: "BBPermissionsKit")],
            path: "Sources/BBPermissionBluetooth",
            swiftSettings: [
                .define("BBPERMISSIONS_BLUETOOTH"),
                .define("BBPERMISSIONSKIT")
            ],
            linkerSettings: [.linkedFramework("CoreBluetooth")]
        ),
        .target(
            name: "BBPermissionNotification",
            dependencies: [.target(name: "BBPermissionsKit")],
            path: "Sources/BBPermissionNotification",
            swiftSettings: [
                .define("BBPERMISSIONS_NOTIFICATION"),
                .define("BBPERMISSIONSKIT")
            ],
            linkerSettings: [.linkedFramework("UserNotifications")]
        ),
        .target(
            name: "BBPermissionReminder",
            dependencies: [.target(name: "BBPermissionsKit")],
            path: "Sources/BBPermissionReminder",
            swiftSettings: [
                .define("BBPERMISSIONS_REMINDER"),
                .define("BBPERMISSIONSKIT")
            ],
            linkerSettings: [.linkedFramework("EventKit")]
        ),
        .target(
            name: "BBPermissionMotion",
            dependencies: [.target(name: "BBPermissionsKit")],
            path: "Sources/BBPermissionMotion",
            swiftSettings: [
                .define("BBPERMISSIONS_MOTION"),
                .define("BBPERMISSIONSKIT")
            ],
            linkerSettings: [.linkedFramework("CoreMotion")]
        ),
        .target(
            name: "BBPermissionSiri",
            dependencies: [.target(name: "BBPermissionsKit")],
            path: "Sources/BBPermissionSiri",
            swiftSettings: [
                .define("BBPERMISSIONS_SIRI"),
                .define("BBPERMISSIONSKIT")
            ],
            linkerSettings: [.linkedFramework("Intents")]
        ),
        .target(
            name: "BBPermissionPhoto",
            dependencies: [.target(name: "BBPermissionsKit")],
            path: "Sources/BBPermissionPhoto",
            swiftSettings: [
                .define("BBPERMISSIONS_PHOTOS"),
                .define("BBPERMISSIONSKIT")
            ],
            linkerSettings: [.linkedFramework("Photos")]
        )
    ],
    swiftLanguageVersions: [.v5]
)
