//
//  FileManager+Shortcuts.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/12/19.
//  Copyright © 2020 Davide De Rosa. All rights reserved.
//

import Foundation

public extension FileManager {
    func userURL(for searchPath: SearchPathDirectory, appending: String?) -> URL {
        let paths = urls(for: searchPath, in: .userDomainMask)
        var directory = paths[0]
        if let appending = appending {
            directory.appendPathComponent(appending)
        }
        return directory
    }
    
    func creationDate(of path: String) -> Date? {
        guard let attrs = try? attributesOfItem(atPath: path) else {
            return nil
        }
        return attrs[.creationDate] as? Date
    }

    func modificationDate(of path: String) -> Date? {
        guard let attrs = try? attributesOfItem(atPath: path) else {
            return nil
        }
        return attrs[.modificationDate] as? Date
    }
}
