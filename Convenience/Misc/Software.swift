//
//  Software.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/9/19.
//  Copyright © 2020 Davide De Rosa. All rights reserved.
//

import Foundation

public struct Software: Comparable {
    public struct License {
        public let type: String
        
        public let url: URL
        
        public init(type: String, urlString: String) {
            self.type = type
            guard let url = URL(string: urlString) else {
                fatalError("Unable to parse URL: \(urlString)")
            }
            self.url = url
        }
    }

    public struct Notice {
        public let statement: String
        
        public init(statement: String) {
            self.statement = statement
        }
    }

    public let name: String

    public let license: License?

    public let notice: Notice?

    public init(_ name: String, license: String, url: String) {
        self.name = name
        self.license = License(type: license, urlString: url)
        notice = nil
    }

    public init(_ name: String, notice: String) {
        self.name = name
        license = nil
        self.notice = Notice(statement: notice)
    }
    
    // MARK: Comparable
    
    public static func ==(lhs: Software, rhs: Software) -> Bool {
        return lhs.name == rhs.name
    }

    public static func <(lhs: Software, rhs: Software) -> Bool {
        return lhs.name < rhs.name
    }
}
