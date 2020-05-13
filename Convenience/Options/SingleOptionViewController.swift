//
//  SingleOptionViewController.swift
//  Convenience
//
//  Created by Davide De Rosa on 8/28/19.
//  Copyright © 2020 Davide De Rosa. All rights reserved.
//

import UIKit

open class SingleOptionViewController<T: Hashable>: UITableViewController {
    private let reuseIdentifier = "Cell"

    public var cellType: UITableViewCell.Type?

    public var options: [T] = []

    public var selectedOption: T?
    
    public var configurationBlock: ((UITableViewCell, T) -> Void)?
    
    public var descriptionBlock: ((T) -> String)?

    public var imageBlock: ((T) -> UIImage)?
    
    public var selectionBlock: ((T) -> Void)?

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public init() {
        super.init(style: .grouped)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(cellType ?? UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
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
        cell.accessoryType = (opt == selectedOption) ? .checkmark : .none
        return cell
    }
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let opt = options[indexPath.row]
        selectionBlock?(opt)
    }
}
