//
//  UIBarButtonItem+Awesome.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/9/19.
//  Copyright © 2019 Davide De Rosa. All rights reserved.
//

import UIKit

public extension AwesomeIcon {
    func barButtonItem(target: Any?, action: Selector?) -> UIBarButtonItem {
        let img = image(color: UIBarButtonItem.appearance().tintColor ?? .black, size: 30.0)
        return UIBarButtonItem(image: img, style: .plain, target: target, action: action)
    }

    func barButtonItem(color: UIColor, target: Any?, action: Selector?) -> UIBarButtonItem {
        let img = image(color: color, size: 30.0)
        return UIBarButtonItem(image: img, style: .plain, target: target, action: action)
    }
}
