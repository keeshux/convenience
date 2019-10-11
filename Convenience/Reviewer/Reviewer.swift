//
//  Reviewer.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/9/19.
//  Copyright © 2019 Davide De Rosa. All rights reserved.
//

import StoreKit

public class Reviewer {
    private struct Keys {
        static let eventCount = "Convenience.Reviewer.EventCount"
    
        static let lastVersion = "Convenience.Reviewer.LastVersion"
    }
    
    public static let shared = Reviewer()
    
    private let defaults: UserDefaults
    
    public var appId: String?
    
    public var eventCountBeforeRating: Int = .max
    
    private init() {
        defaults = .standard
    }

    @discardableResult
    public func reportEvent() -> Bool {
        return reportEvents(1)
    }

    @discardableResult
    public func reportEvents(_ eventCount: Int, appStoreId: String? = nil) -> Bool {
        guard let currentVersionString = Bundle.main.infoDictionary?["CFBundleVersion"] as? String, let currentVersion = Int(currentVersionString) else {
            return false
        }
        let lastVersion = defaults.integer(forKey: Keys.lastVersion)
        if lastVersion > 0 {
            print("Convenience.Reviewer: App last reviewed for version \(lastVersion)")
        } else {
            print("Convenience.Reviewer: App was never reviewed")
        }
        guard currentVersion != lastVersion else {
            print("Convenience.Reviewer: App already reviewed for version \(currentVersion)")
            return false
        }

        var count = defaults.integer(forKey: Keys.eventCount)
        count += eventCount
        defaults.set(count, forKey: Keys.eventCount)
        print("Convenience.Reviewer: Event reported for version \(currentVersion) (count: \(count), prompt: \(eventCountBeforeRating))")
        
        guard count >= eventCountBeforeRating else {
            return false
        }
        print("Convenience.Reviewer: Prompting for review...")

        defaults.removeObject(forKey: Keys.eventCount)
        defaults.set(currentVersion, forKey: Keys.lastVersion)
        
        requestReview()
        return true
    }
    
    private func requestReview() {
        guard #available(iOS 11, macOS 10.14, *) else {
            return
        }

        // may or may not appear
        SKStoreReviewController.requestReview()
    }

    public static func urlForReview(withAppId appId: String) -> URL {
        return URL(string: "https://itunes.apple.com/app/id\(appId)?action=write-review")!
    }
}
