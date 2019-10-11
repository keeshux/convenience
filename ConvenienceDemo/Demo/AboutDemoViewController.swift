//
//  AboutDemoViewController.swift
//  ConvenienceDemo
//
//  Created by Davide De Rosa on 9/9/19.
//  Copyright © 2019 Davide De Rosa. All rights reserved.
//

import UIKit
import Convenience

class AboutDemoViewController: UIViewController {
    @IBAction private func showVersion() {
        let vc = VersionViewController()
        vc.appIcon = UIImage(named: "AppIcon")
        vc.extraText = "This is a demo app for Convenience"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func showLicense() {
        let software = Software(
            name: "MBProgressHUD",
            license: Software.License(
                "MIT",
                "https://raw.githubusercontent.com/jdg/MBProgressHUD/master/LICENSE"
            )
        )
        let vc = SoftwareUsageViewController()
        vc.software = software
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction private func showNotice() {
        let software = Software(
            name: "Proprietary",
            notice: Software.Notice(
                "This is proprietary software. Do not use it."
            )
        )
        let vc = SoftwareUsageViewController()
        vc.software = software
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction private func showCredits() {
        let vc = CreditsViewController()
        vc.software = [
            Software(
                name: "MBProgressHUD",
                license: Software.License(
                    "MIT",
                    "https://raw.githubusercontent.com/jdg/MBProgressHUD/master/LICENSE"
                )
            ),
            Software(
                name: "SwiftGen",
                license: Software.License(
                    "MIT",
                    "https://raw.githubusercontent.com/SwiftGen/SwiftGen/master/LICENCE"
                )
            ),
            Software(
                name: "SwiftyBeaver",
                license: Software.License(
                    "MIT",
                    "https://raw.githubusercontent.com/SwiftyBeaver/SwiftyBeaver/master/LICENSE"
                )
            ),
            Software(
                name: "Circle Icons",
                notice: Software.Notice(
                    "The logo is taken from the awesome Circle Icons set by Nick Roach."
                )
            )
        ]
        navigationController?.pushViewController(vc, animated: true)
    }
}
