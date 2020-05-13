//
//  UILabel+Awesome.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/9/19.
//  Copyright © 2020 Davide De Rosa. All rights reserved.
//

import UIKit

public extension UILabel {
    func setAwesomeIcon(_ icon: AwesomeIcon, size: CGFloat) {
        font = UIFont.fontAwesome(ofSize: size, style: icon.style)
        text = String.fontAwesomeIcon(name: icon.name)
    }
}
