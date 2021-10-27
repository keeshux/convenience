//
//  KeychainDemoViewController.swift
//  ConvenienceDemo
//
//  Created by Davide De Rosa on 9/9/19.
//  Copyright © 2021 Davide De Rosa. All rights reserved.
//

#if canImport(UIKit)
import UIKit
#endif
import Convenience

class KeychainDemoViewController: UIViewController {
    @IBOutlet private weak var labelPassword: UILabel?
    
    private let keychain = Keychain()
    
    private let username = "foobar"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            labelPassword?.text = try keychain.password(for: username)
        } catch let e {
            print(e)
        }
    }
    
    @IBAction private func setRandomPassword() {
        var rand = SystemRandomNumberGenerator()
        let num = rand.next()
        let password = String(format: "%x", num)
        do {
            try keychain.set(password: password, for: username)
            labelPassword?.text = password
        } catch let e {
            print(e)
        }
    }
}
