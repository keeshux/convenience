//
//  StrongTableModel.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/1/19.
//  Copyright © 2020 Davide De Rosa. All rights reserved.
//

import UIKit

public class StrongTableModel<S: Hashable, R: Equatable> {
    private var sections: [S]
    
    private var headerBySection: [S: String]
    
    private var footerBySection: [S: String]
    
    private var rowsBySection: [S: [R]]
    
    public init() {
        sections = []
        headerBySection = [:]
        footerBySection = [:]
        rowsBySection = [:]
    }
    
    public func clear() {
        sections = []
        headerBySection = [:]
        footerBySection = [:]
        rowsBySection = [:]
    }

    // MARK: Access
    
    public var numberOfSections: Int {
        return sections.count
    }

    public func section(forIndex sectionIndex: Int) -> S {
        return sections[sectionIndex]
    }
    
    public func index(ofSection sectionObject: S) -> Int {
        guard let sectionIndex = sections.firstIndex(of: sectionObject) else {
            fatalError("Missing section: \(sectionObject)")
        }
        return sectionIndex
    }

    public func rows(forSection sectionIndex: Int) -> [R] {
        let sectionObject = sections[sectionIndex]
        guard let rows = rowsBySection[sectionObject] else {
            fatalError("Missing section: \(sectionObject)")
        }
        return rows
    }
    
    public func row(at indexPath: IndexPath) -> R {
        return rows(forSection: indexPath.section)[indexPath.row]
    }
    
    public func numberOfRows(forSection sectionIndex: Int) -> Int {
        return rows(forSection: sectionIndex).count
    }
    
    public func indexPath(forRow rowObject: R, ofSection sectionObject: S) -> IndexPath? {
        guard let sectionIndex = sections.firstIndex(of: sectionObject) else {
            return nil
        }
        guard let row = rowsBySection[sectionObject]?.firstIndex(of: rowObject) else {
            return nil
        }
        return IndexPath(row: row, section: sectionIndex)
    }
    
    public func header(forSection sectionIndex: Int) -> String? {
        let sectionObject = sections[sectionIndex]
        return headerBySection[sectionObject]
    }

    public func header(forSection sectionObject: S) -> String? {
        return headerBySection[sectionObject]
    }

    public func footer(forSection sectionIndex: Int) -> String? {
        let sectionObject = sections[sectionIndex]
        return footerBySection[sectionObject]
    }

    public func footer(forSection sectionObject: S) -> String? {
        return footerBySection[sectionObject]
    }

    // MARK: Modification
    
    public func add(_ section: S) {
        sections.append(section)
    }

    public func setHeader(_ header: String, forSection sectionObject: S) {
        headerBySection[sectionObject] = header
    }
    
    public func removeHeader(forSection sectionObject: S) {
        headerBySection.removeValue(forKey: sectionObject)
    }
    
    public func setFooter(_ footer: String, forSection sectionObject: S) {
        footerBySection[sectionObject] = footer
    }
    
    public func removeFooter(forSection sectionObject: S) {
        footerBySection.removeValue(forKey: sectionObject)
    }

    public func set(_ rows: [R], forSection sectionObject: S) {
        rowsBySection[sectionObject] = rows
    }

    public func set(_ row: R, count: Int, forSection sectionObject: S) {
        rowsBySection[sectionObject] = [R](repeating: row, count: count)
    }
    
    public func deleteRow(at indexPath: IndexPath) {
        deleteRow(at: indexPath.row, ofSection: section(forIndex: indexPath.section))
    }

    public func deleteRow(at rowIndex: Int, ofSection sectionObject: S) {
        rowsBySection[sectionObject]?.remove(at: rowIndex)
    }
}
