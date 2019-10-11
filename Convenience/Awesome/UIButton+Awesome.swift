//
//  UIButton+Awesome.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/9/19.
//  Copyright © 2019 Davide De Rosa. All rights reserved.
//

import UIKit

public extension UIButton {
    func setAwesomeIcon(_ icon: AwesomeIcon, size: CGFloat) {
        titleLabel?.font = UIFont.fontAwesome(ofSize: size, style: icon.style)
        setTitle(String.fontAwesomeIcon(name: icon.name), for: .normal)
    }
}
