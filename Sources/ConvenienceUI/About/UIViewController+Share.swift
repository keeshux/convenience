//
//  UIViewController+Share.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/20/19.
//  Copyright © 2021 Davide De Rosa. All rights reserved.
//

#if canImport(UIKit)
import UIKit
import Convenience

extension UIViewController {
    public func shareApp(withAppStoreId appStoreId: String, message: String, sourceView: UIView?) {
        let text = "\(message) \(ApplicationInfo.appStoreURL(withAppStoreId: appStoreId))"
        
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = sourceView
        present(vc, animated: true, completion: nil)
    }
}
#endif
