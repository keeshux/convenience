//
//  StrongTableHost.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/1/19.
//  Copyright © 2021 Davide De Rosa. All rights reserved.
//

import Foundation

public protocol StrongTableHost {
    associatedtype S: Hashable
    
    associatedtype R: Equatable
    
    var model: StrongTableModel<S, R> { get }
    
    func reloadModel()
}
