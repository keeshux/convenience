//
//  ApplicationInfo.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/18/19.
//  Copyright © 2019 Davide De Rosa. All rights reserved.
//

import UIKit

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

    public static var osVersion: String {
        let device = UIDevice.current
        return "\(device.systemName) \(device.systemVersion)"
    }
    
    public static var deviceModel: String {
        return UIDevice.current.model
    }
    
    public static func appStoreURL(withAppStoreId appStoreId: String) -> URL {
        return URL(string: "https://apps.apple.com/us/app/id\(appStoreId)")!
    }
}
