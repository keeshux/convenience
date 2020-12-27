//
//  HUD.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/9/19.
//  Copyright © 2021 Davide De Rosa. All rights reserved.
//

import UIKit
import MBProgressHUD

public class HUD {
    public static var backgroundColor = UIColor(white: 0.0, alpha: 0.6)
    
    private let backend: MBProgressHUD

//    public convenience init(label: String? = nil) {
//        guard let window = UIApplication.shared.windows.first else {
//            fatalError("Could not locate target window")
//        }
//        self.init(window: window, label: label)
//    }
        
    public init(view: UIView, label: String? = nil) {
        backend = MBProgressHUD.showAdded(to: view, animated: true)
        backend.label.text = label
        backend.backgroundView.backgroundColor = HUD.backgroundColor
        backend.mode = .indeterminate
        backend.removeFromSuperViewOnHide = true
    }

    public func show() {
        backend.show(animated: true)
    }
    
    public func hide() {
        backend.hide(animated: true)
    }
}
