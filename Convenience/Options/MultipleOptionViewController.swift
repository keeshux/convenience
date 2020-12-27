//
//  MultipleOptionViewController.swift
//  Convenience
//
//  Created by Davide De Rosa on 8/28/19.
//  Copyright © 2021 Davide De Rosa. All rights reserved.
//

import UIKit

open class MultipleOptionViewController<T: Hashable>: UITableViewController {
    private let reuseIdentifier = "Cell"
    
    public var cellType: UITableViewCell.Type?

    public var options: [T] = []

    public var selectedOptions: Set<T>?
    
    public var configurationBlock: ((UITableViewCell, T) -> Void)?
    
    public var descriptionBlock: ((T) -> String)?

    public var imageBlock: ((T) -> UIImage)?

    public var selectionBlock: ((Set<T>) -> Void)?
    
    public lazy var newSelectedOptions = selectedOptions ?? Set()
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public init() {
        super.init(style: .grouped)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(cellType ?? UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }

    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    open override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let opt = options[indexPath.row]
        configurationBlock?(cell, opt)
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let opt = options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = descriptionBlock?(opt)
        cell.imageView?.image = imageBlock?(opt)
        cell.accessoryType = newSelectedOptions.contains(opt) ? .checkmark : .none
        cell.selectionStyle = .none
        return cell
    }
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let opt = options[indexPath.row]
        if newSelectedOptions.contains(opt) {
            newSelectedOptions.remove(opt)
        } else {
            newSelectedOptions.insert(opt)
        }
        tableView.reloadData()
    }
    
    @objc private func done() {
//        var sortedOptions: [T] = []
//        for opt in options {
//            guard newSelectedOptions.contains(opt) else {
//                continue
//            }
//            sortedOptions.append(opt)
//        }
//        selectionBlock?(sortedOptions)
        selectionBlock?(newSelectedOptions)
    }
}
