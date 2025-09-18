[![Swift 5.0](https://img.shields.io/badge/Swift-5.x+-orange.svg?style=flat)](https://developer.apple.com/swift/)
![Pod](https://img.shields.io/cocoapods/p/RippleEffectView.svg?style=flat)
# BBPermission

BBPermissions is a Swift framework that makes handling various iOS system permissions (Location, Camera, Microphone, etc.) a breeze. Manage permission status checks, requests, and denials all in one go! 🎉 This framework hides complex permission logic behind simple APIs, letting developers build apps faster. 😎

## Requirements

- **iOS**: 13.0+
- **Swift**: 5.0+
- **Xcode**: 16.1+

## Installation

Download the source code from GitHub and add only the permissions you need to your project. No need to bloat your app with unnecessary features! ~ Even if you add more permissions later, the way you call and handle them stays the same. However, the following components are required:

- Permission/Enum
- Permission/Protocol

## Usage

``` Swift
// Health Permission
let healthPermission = BBPermissionHealth(readTypes: [.workoutType()], writeTypes: [.workoutType()])
Task {
    let status = await healthPermission.status()
    if status == .authorized {
        debugPrint("Now Access Health")
    } else {
        let result = await healthPermission.requestPermission(with: true)
        debugPrint("Health Permission Status : \(result)")
        
    }
    debugPrint("Status : \(await healthPermission.status())")
}
```

``` Swift
// Camera Permission
let cameraPermission = BBPermissionCamera()
let status = cameraPermission.status()
if status == .authorized {
    debugPrint("Now Access Camera")
} else {
    Task {
        let result = await cameraPermission.requestPermission(with: true)
        debugPrint("Camera Permission Status : \(result)")
    }
}
```

``` Swift
// Camera Permission with Custom No Access Message
let cameraPermission = BBPermissionCamera()
cameraPermission.setCustomNoAccessMessage("Snap! I need the camera to capture your epic moments! 📸")
let status = cameraPermission.status()
if status == .authorized {
    debugPrint("Now Access Camera")
} else {
    Task {
        let result = await cameraPermission.requestPermission(with: true)
        debugPrint("Camera Permission Status : \(result)")
    }
}
```

## Contributing

We welcome contributions! 😊 If you want to fix bugs or add new features, follow these steps:

1. Check GitHub to see if there’s an existing issue.
2. Open a new issue or submit a pull request.
3. Follow SwiftLint for code style.

## License

This project is distributed under the MIT License. See the LICENSE file for details.

```
 MIT License
 Copyright (c) 2025 Beakbig

 You're now the proud owner of Beakbig's awesome software! 🎉
 Use it, tweak it, share it, sell it—go wild! 🚀
 Just keep this copyright notice and license text in all copies,
 like a shiny "Made by Beakbig!" badge. 😜

 This software comes "as is"—no promises it’s perfect
 or fit for your grand plans. 😅
 If it breaks or causes trouble, Beakbig isn’t liable,
 so you’re on your own for this adventure! 😎

 Found a bug or have a genius idea?
 Raise an issue at https://github.com/DillanK/BBPermission/issues
 or email salon@beakbig.com to make this software even cooler! 🌟
```

## Support

If you run into issues or need help:

- GitHub Issues: [https://github.com/yourusername/BeakbigPermissions/issues](https://github.com/yourusername/BeakbigPermissions/issues)
- Email: [salon@beakbig.com](mailto:salon@beakbig.com)

## Acknowledgments

- A big thank you to the open-source community contributors.

⭐ If this project helped you, please give it a star! Help more developers handle permissions with ease. 😄

---

This translation keeps the original formatting and tone, ensuring the content is suitable for a GitHub README. Let me know if you need further tweaks or additional sections! 😄
