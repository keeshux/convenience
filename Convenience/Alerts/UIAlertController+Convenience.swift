//
//  UIAlertController+Convenience.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/2/19.
//  Copyright © 2020 Davide De Rosa. All rights reserved.
//

import UIKit

public extension UIAlertController {
    static func asAlert(_ title: String?, _ message: String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    static func asActionSheet(_ title: String?, _ message: String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    }

    // The preferred action is relevant for the UIAlertController.Style.alert style only; it is not used by action sheets.
    @discardableResult func addAction(_ title: String, isPreferred: Bool = false, handler: @escaping () -> Void) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: .default) { (action) in
            handler()
        }
        addAction(action)
        if isPreferred {
            preferredAction = action
        }
        return action
    }
    
    @discardableResult func addPreferredAction(_ title: String, handler: @escaping () -> Void) -> UIAlertAction {
        return addAction(title, isPreferred: true, handler: handler)
    }
    
    @discardableResult func addCancelAction(_ title: String, handler: (() -> Void)? = nil) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: .cancel) { (action) in
            handler?()
        }
        addAction(action)
        return action
    }
    
    @discardableResult func addDestructiveAction(_ title: String, handler: @escaping () -> Void) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: .destructive) { (action) in
            handler()
        }
        addAction(action)
        return action
    }
}
