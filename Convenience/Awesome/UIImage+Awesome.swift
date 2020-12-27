//
//  UIImage+Awesome.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/9/19.
//  Copyright © 2021 Davide De Rosa. All rights reserved.
//

import UIKit

public extension AwesomeIcon {
    func image(color: UIColor, size: CGFloat) -> UIImage {
        return .fontAwesomeIcon(
            name: name,
            style: style,
            textColor: color,
            size: CGSize(width: size, height: size)
        )
    }
}
