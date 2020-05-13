//
//  URL+MailTo.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/12/19.
//  Copyright © 2020 Davide De Rosa. All rights reserved.
//

import Foundation

public extension URL {
    static func mailto(to: String, subject: String, body: String) -> URL? {
        guard let escapedSubject = subject.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            return nil
        }
        guard let escapedBody = body.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            return nil
        }
        return URL(string: "mailto:\(to)?subject=\(escapedSubject)&body=\(escapedBody)")
    }
}
