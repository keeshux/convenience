//
//  OptionsDemoViewController.swift
//  ConvenienceDemo
//
//  Created by Davide De Rosa on 9/2/19.
//  Copyright © 2021 Davide De Rosa. All rights reserved.
//

import UIKit
import Convenience

class OptionsDemoViewController: UIViewController {
    @IBOutlet private weak var labelSingle: UILabel?
    
    @IBOutlet private weak var labelMultiple: UILabel?
    
    let options = ["One", "Two", "Three", "Four", "Five"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction private func pickSingle() {
        let vc = SingleOptionViewController<String>()
        vc.options = options
        vc.selectedOption = labelSingle?.text
        vc.configurationBlock = {
            $0.textLabel?.textColor = .blue
        }
        vc.descriptionBlock = { $0 }
        vc.selectionBlock = {
            self.labelSingle?.text = $0
            self.dismiss(animated: true, completion: nil)
        }
        present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }

    @IBAction private func pickMultiple() {
        let vc = MultipleOptionViewController<String>()
        vc.options = options
        if let selectedOptions = labelMultiple?.text?.split(separator: ",") {
            vc.selectedOptions = Set(selectedOptions.map { String($0) })
        }
        vc.configurationBlock = {
            $0.textLabel?.textColor = .blue
        }
        vc.descriptionBlock = { $0 }
        vc.selectionBlock = {
            self.labelMultiple?.text = $0.joined(separator: ",")
            self.dismiss(animated: true, completion: nil)
        }
        present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
}

