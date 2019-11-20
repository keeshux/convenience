//
//  Response.swift
//  Convenience
//
//  Created by Davide De Rosa on 11/20/19.
//  Copyright © 2019 Davide De Rosa. All rights reserved.
//

import Foundation

public struct Response<T> {
    public let value: T?
    
    public let lastModifiedString: String?
    
    public var lastModified: Date? {
        guard let string = lastModifiedString else {
            return nil
        }
        return ResponseParser.lastModifiedDate(string: string)
    }
    
    public let isCached: Bool
}
