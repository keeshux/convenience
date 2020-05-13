//
//  StrongTablesDemoViewController.swift
//  ConvenienceDemo
//
//  Created by Davide De Rosa on 9/1/19.
//  Copyright © 2020 Davide De Rosa. All rights reserved.
//

import UIKit
import Convenience

class StrongTablesDemoViewController: UITableViewController, StrongTableHost {
    let reuseIdentifier = "BasicCell"
    
    var model: StrongTableModel<SectionType, RowType> = StrongTableModel()

    func reloadModel() {
        model.clear()

        model.add(.general)
        model.add(.preferences)
        model.add(.advanced)
        
        model.setHeader("General", forSection: .general)
        model.setHeader("Preferences", forSection: .preferences)
        model.setHeader("Advanced", forSection: .advanced)
        
        model.set([.darkMode, .enableNotifications], forSection: .general)
        model.set([.sleepOnIdle, .customizeFont], forSection: .preferences)
        model.set([.veryTechnicalOption, .enableDebugging], forSection: .advanced)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reloadModel()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.header(forSection: section)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfRows(forSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = model.row(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = row.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = model.row(at: indexPath)
        print(row.rawValue)
    }
}

enum SectionType: String {
    case general
    
    case preferences
    
    case advanced
}

enum RowType: String, CustomStringConvertible {
    case darkMode
    
    case enableNotifications
    
    case sleepOnIdle
    
    case customizeFont
    
    case veryTechnicalOption
    
    case enableDebugging
    
    var description: String {
        switch self {
        case .darkMode: return "Dark mode"
        case .enableNotifications: return "Enable notifications"
        case .sleepOnIdle: return "Sleep on idle"
        case .customizeFont: return "Customize font"
        case .veryTechnicalOption: return "Very technical option"
        case .enableDebugging: return "Debugging"
        }
    }
}
