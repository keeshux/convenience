//
//  UIViewController+Awesome.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/9/19.
//  Copyright © 2019 Davide De Rosa. All rights reserved.
//

import UIKit

public extension UIViewController {
    func awesomeItem(withIcon icon: AwesomeIcon, action: Selector) -> UIBarButtonItem {
        return icon.barButtonItem(target: self, action: action)
    }
}
