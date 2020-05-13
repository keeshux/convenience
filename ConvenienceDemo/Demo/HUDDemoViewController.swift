//
//  HUDDemoViewController.swift
//  ConvenienceDemo
//
//  Created by Davide De Rosa on 9/9/19.
//  Copyright © 2020 Davide De Rosa. All rights reserved.
//

import UIKit
import Convenience

class HUDDemoViewController: UIViewController {
    @IBAction private func startActivity() {
        let hud = HUD(window: nil, label: "Wait...")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            hud.hide()
        }
    }
}
