//
//  SoftwareUsageViewController.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/9/19.
//  Copyright © 2021 Davide De Rosa. All rights reserved.
//

#if canImport(UIKit)
import UIKit
import Convenience

public class SoftwareUsageViewController: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView?

    @IBOutlet private weak var activity: UIActivityIndicatorView?
    
    @IBOutlet private weak var label: UILabel?
    
    private static var cachedContent: [String: String] = [:]

    public var software: Software?
    
    public var errorString: String?

    public var backgroundColor: UIColor?

    public var textColor: UIColor?

    public var accentColor: UIColor?

    public convenience init() {
        self.init(nibName: nil, bundle: Bundle.module)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        title = software?.name
        activity?.hidesWhenStopped = true
        if #available(iOS 13, *) {
            scrollView?.backgroundColor = backgroundColor ?? .systemBackground
            label?.textColor = textColor ?? .label
            activity?.color = accentColor ?? .label
        } else {
            scrollView?.backgroundColor = backgroundColor
            label?.textColor = textColor
            activity?.color = accentColor
        }

        guard let software = software else {
            return
        }
        if let notice = software.notice {
            label?.text = notice.statement
            return
        }
        guard let license = software.license else {
            return
        }
        
        // try cache first
        if let cachedContent = SoftwareUsageViewController.cachedContent[software.name] {
            label?.text = cachedContent
            return
        }
        
        label?.text = nil
        activity?.startAnimating()

        DispatchQueue(label: SoftwareUsageViewController.description(), qos: .background).async { [weak self] in
            let content: String
            let couldFetch: Bool
            do {
                content = try String(contentsOf: license.url)
                couldFetch = true
            } catch {
                content = self?.errorString ?? ""
                couldFetch = false
            }
            DispatchQueue.main.async {
                self?.label?.text = content
                self?.activity?.stopAnimating()
                
                if couldFetch {
                    SoftwareUsageViewController.cachedContent[software.name] = content
                }
            }
        }
    }
}
#endif
