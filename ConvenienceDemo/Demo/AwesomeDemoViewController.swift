//
//  AwesomeDemoViewController.swift
//  ConvenienceDemo
//
//  Created by Davide De Rosa on 9/9/19.
//  Copyright © 2019 Davide De Rosa. All rights reserved.
//

import UIKit
import Convenience

class AwesomeDemoViewController: UIViewController {
    @IBOutlet private weak var label: UILabel?
    
    @IBOutlet private weak var button: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label?.setAwesomeIcon(AwesomeIcon(.solid, .sortNumericDown, size: 24.0))
        button?.setAwesomeIcon(AwesomeIcon(.brands, .twitter, size: 36.0))
        navigationItem.rightBarButtonItem = awesomeItem(
            withIcon: AwesomeIcon(.solid, .trashAlt, size: 24.0),
            color: .red,
            action: #selector(itemTapped)
        )
    }
    
    @objc private func itemTapped() {
        print("Item tapped!")
    }
}
