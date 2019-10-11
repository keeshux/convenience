//
//  CreditsViewController.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/9/19.
//  Copyright © 2019 Davide De Rosa. All rights reserved.
//

import UIKit

public class CreditsViewController: UITableViewController, StrongTableHost {
    private class Cell: UITableViewCell {
        static let reuseIdentifier = "Cell"
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError()
        }
    }
    
    public var software: [Software] = []
    
    private var licenses: [Software] = []
    
    private var notices: [Software] = []
    
    public var licensesHeader = "Licenses"
    
    public var noticesHeader = "Notices"
    
    // MARK: StrongTableModelHost
    
    public var model: StrongTableModel<SectionType, RowType> = StrongTableModel()
    
    public func reloadModel() {
        model.add(.licenses)
        model.add(.notices)
        
        model.setHeader(licensesHeader, forSection: .licenses)
        model.setHeader(noticesHeader, forSection: .notices)

        model.set(.license, count: licenses.count, forSection: .licenses)
        model.set(.notice, count: notices.count, forSection: .notices)
    }
    
    // MARK: UIViewController
    
    public convenience init() {
        self.init(style: .grouped)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if title == nil {
            title = "Credits"
        }
        licenses = software.filter { $0.license != nil }.sorted()
        notices = software.filter { $0.notice != nil }.sorted()

        tableView.register(Cell.classForCoder(), forCellReuseIdentifier: Cell.reuseIdentifier)
        reloadModel()
    }
}

extension CreditsViewController {
    public enum SectionType: Int {
        case licenses
        
        case notices
    }

    public enum RowType: Int {
        case license
        
        case notice
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return model.numberOfSections
    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.header(forSection: section)
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfRows(forSection: section)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath)
        switch model.row(at: indexPath) {
        case .license:
            let obj = licenses[indexPath.row]
            cell.textLabel?.text = obj.name
            cell.detailTextLabel?.text = obj.license?.type

        case .notice:
            let obj = notices[indexPath.row]
            cell.textLabel?.text = obj.name
            cell.detailTextLabel?.text = nil
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SoftwareUsageViewController()
        switch model.row(at: indexPath) {
        case .license:
            vc.software = licenses[indexPath.row]
            
        case .notice:
            vc.software = notices[indexPath.row]
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
