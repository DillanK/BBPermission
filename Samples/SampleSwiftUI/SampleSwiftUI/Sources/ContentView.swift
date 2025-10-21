//
//  ContentView.swift
//  SampleSwiftUI
//
//  Created by hyunjin on 10/2/25.
//

import SwiftUI
import BBPermissionsKit

struct PermissionStatus {
    var statusTitle: String
    var status: BBPermissionStatus
    
    init(statusTitle: String, status: BBPermissionStatus) {
        self.statusTitle = statusTitle
        self.status = status
    }
    
    func getStatusDisplayInfo() -> (String, Color) {
        switch status {
            case .authorized:
                return ("승인", Color("AuthrizedText", bundle: nil))
            case .denied:
                return ("거부", Color("DeniedText", bundle: nil))
            case .notDetermined:
                return ("요청 필요", Color("DeterminedText", bundle: nil))
            case .limitedAuthorized:
                return ("제한된 권한", Color("LimitAuthrizedText", bundle: nil))
            default:
                return ("거부", Color("DeniedText", bundle: nil))
        }
    }
}

struct ContentView: View {
    
    @State var permissionStatus: [String : PermissionStatus]
    
    init() {
        permissionStatus = PermissionType.allCases.reduce(into: [:], { partialResult, type in
            partialResult["\(type)"] = .init(statusTitle: type.getTitle(), status: type.makePermission().status())
        })
    }
    
    var body: some View {
        ScrollView {
            ForEach(PermissionType.allCases, id: \.self) { type in
                LazyVStack(alignment: .leading) {
                    Text(type.getTitle())
                    HStack {
                        Text("권한 상태 : ")
                        if let statusInfo = permissionStatus["\(type)"]?.getStatusDisplayInfo() {
                            Text(statusInfo.0).foregroundStyle(statusInfo.1)
                        }
                    }.padding(.init(top: 4, leading: 4, bottom: 0, trailing: 0))
                }
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    DispatchQueue.main.async {
                        type.makePermission().requestPermission(with: true) { status in
                            permissionStatus["\(type)"] = .init(statusTitle: type.getTitle(), status: status)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
