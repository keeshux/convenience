//
//  UIViewController+Share.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/20/19.
//  Copyright © 2020 Davide De Rosa. All rights reserved.
//

import UIKit

extension UIViewController {
    public func shareApp(withAppStoreId appStoreId: String, message: String, sourceView: UIView?) {
        let text = "\(message) \(ApplicationInfo.appStoreURL(withAppStoreId: appStoreId))"
        
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = sourceView
        present(vc, animated: true, completion: nil)
    }
}
