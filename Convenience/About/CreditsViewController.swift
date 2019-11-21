//
//  CreditsViewController.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/9/19.
//  Copyright © 2019 Davide De Rosa. All rights reserved.
//

import UIKit

open class CreditsViewController: UITableViewController, StrongTableHost {
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
    
    public var translators: [String: String] = [:]
    
    private lazy var languages = translators.keys.sorted {
        return localizedLanguage($0) < localizedLanguage($1)
    }

    public var licensesHeader = "Licenses"
    
    public var noticesHeader = "Notices"
    
    public var translationsHeader = "Translations"
    
    public var accentColor: UIColor?
    
    // MARK: StrongTableModelHost
    
    public var model: StrongTableModel<SectionType, RowType> = StrongTableModel()
    
    public func reloadModel() {
        if !licenses.isEmpty {
            model.add(.licenses)
            model.setHeader(licensesHeader, forSection: .licenses)
            model.set(.license, count: licenses.count, forSection: .licenses)
        }
        if !notices.isEmpty {
            model.add(.notices)
            model.setHeader(noticesHeader, forSection: .notices)
            model.set(.notice, count: notices.count, forSection: .notices)
        }
        if !languages.isEmpty {
            model.add(.translations)
            model.setHeader(translationsHeader, forSection: .translations)
            model.set(.translation, count: languages.count, forSection: .translations)
        }
    }
    
    // MARK: UIViewController
    
    public convenience init() {
        self.init(style: .grouped)
    }
    
    open override func viewDidLoad() {
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
        
        case translations
    }

    public enum RowType: Int {
        case license
        
        case notice
        
        case translation
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
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default

        case .notice:
            let obj = notices[indexPath.row]
            cell.textLabel?.text = obj.name
            cell.detailTextLabel?.text = nil
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default

        case .translation:
            let lang = languages[indexPath.row]
            guard let author = translators[lang] else {
                fatalError("Author not found for language \(lang)")
            }
            cell.textLabel?.text = localizedLanguage(lang)
            cell.detailTextLabel?.text = author
            cell.accessoryType = .none
            cell.selectionStyle = .none
        }
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let software: Software
        switch model.row(at: indexPath) {
        case .license:
            software = licenses[indexPath.row]
            
        case .notice:
            software = notices[indexPath.row]
            
        case .translation:
            return
        }
        let vc = SoftwareUsageViewController()
        vc.software = software
        vc.accentColor = accentColor
        navigationController?.pushViewController(vc, animated: true)
    }
}

private func localizedLanguage(_ code: String) -> String {
    return Locale.current.localizedString(forLanguageCode: code)?.capitalized ?? code
}
