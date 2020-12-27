//
//  AwesomeIcon.swift
//  Convenience
//
//  Created by Davide De Rosa on 8/30/19.
//  Copyright © 2021 Davide De Rosa. All rights reserved.
//

import Foundation
import FontAwesome_swift

public struct AwesomeIcon: Equatable {
    public let style: FontAwesomeStyle
    
    public let name: FontAwesome
    
    public init(_ style: FontAwesomeStyle, _ name: FontAwesome) {
        self.style = style
        self.name = name
    }

    // MARK: Equatable
    
    public static func ==(lhs: AwesomeIcon, rhs: AwesomeIcon) -> Bool {
        return lhs.style == rhs.style && lhs.name == rhs.name
    }
}
