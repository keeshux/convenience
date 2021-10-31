//
//  ApplicationInfo.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/18/19.
//  Copyright © 2021 Davide De Rosa. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

public class ApplicationInfo {
    public static var appVersion: String {
        let info = Bundle.main.infoDictionary
        guard let version = info?["CFBundleShortVersionString"] else {
            fatalError("No bundle version?")
        }
        guard let build = info?["CFBundleVersion"] else {
            fatalError("No bundle build number?")
        }
        return "\(version) (\(build))"
    }

    public static func appStoreURL(withAppStoreId appStoreId: String) -> URL {
        return URL(string: "https://apps.apple.com/us/app/id\(appStoreId)")!
    }

#if os(iOS)
    public static var osVersion: String {
        let device = UIDevice.current
        return "\(device.systemName) \(device.systemVersion)"
    }
    
    public static var deviceModel: String {
        return UIDevice.current.model
    }
#endif
}
