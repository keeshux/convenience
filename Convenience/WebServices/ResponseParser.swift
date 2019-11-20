//
//  ResponseParser.swift
//  Convenience
//
//  Created by Davide De Rosa on 11/20/19.
//  Copyright © 2019 Davide De Rosa. All rights reserved.
//

import Foundation

public class ResponseParser {
    private static let lmFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "en")
        fmt.timeZone = TimeZone(abbreviation: "GMT")
        fmt.dateFormat = "EEE, dd LLL yyyy HH:mm:ss zzz"
        return fmt
    }()

    public static func lastModifiedDate(string: String) -> Date? {
        return lmFormatter.date(from: string)
    }

    public static func lastModifiedString(date: Date) -> String {
        return lmFormatter.string(from: date)
    }
}
