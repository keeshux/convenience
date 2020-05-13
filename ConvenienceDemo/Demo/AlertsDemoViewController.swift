//
//  AlertsDemoViewController.swift
//  ConvenienceDemo
//
//  Created by Davide De Rosa on 9/2/19.
//  Copyright © 2020 Davide De Rosa. All rights reserved.
//

import UIKit
import Convenience

class AlertsDemoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction private func showAlertOK() {
        let alert = UIAlertController.asAlert(title, "Press OK.")
        alert.addCancelAction("OK")
        present(alert, animated: true, completion: nil)
    }

    @IBAction private func showAlertOKCancel() {
        let alert = UIAlertController.asAlert(title, "Press OK or Cancel.")
        alert.addAction("OK") {
            print("You pressed OK!")
        }
        alert.addCancelAction("Cancel")
        present(alert, animated: true, completion: nil)
    }

    @IBAction private func showAlertMultiple() {
        let alert = UIAlertController.asAlert(title, "Press any button.")
        alert.addPreferredAction("OK") {
            print("You pressed OK!")
        }
        alert.addAction("Another") {
            print("You pressed another button!")
        }
        alert.addCancelAction("Cancel")
        present(alert, animated: true, completion: nil)
    }

    @IBAction private func showSheetOK() {
        let alert = UIAlertController.asActionSheet(title, "Press OK.")
        alert.addCancelAction("OK")
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func showSheetOKCancel() {
        let alert = UIAlertController.asActionSheet(title, "Press OK or Cancel.")
        alert.addPreferredAction("OK") {
            print("You pressed OK!")
        }
        alert.addCancelAction("Cancel")
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func showSheetDestructive() {
        let alert = UIAlertController.asActionSheet(title, "Press any button.")
        alert.addPreferredAction("OK") {
            print("You pressed OK!")
        }
        alert.addCancelAction("Cancel") {
            print("You cancelled")
        }
        alert.addDestructiveAction("Destroy") {
            print("You destroyed everything!")
        }
        present(alert, animated: true, completion: nil)
    }
}

