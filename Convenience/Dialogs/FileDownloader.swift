//
//  FileDownloader.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/9/19.
//  Copyright © 2021 Davide De Rosa. All rights reserved.
//

import Foundation
import MBProgressHUD

public class FileDownloader: NSObject {
    private let temporaryURL: URL
    
    private let timeout: TimeInterval
    
//    public var backgroundColor: UIColor?
//    
//    public var tintColor: UIColor?
    
    private var hud: MBProgressHUD?
    
    private var completionHandler: ((URL?, Error?) -> Void)?
    
    public init(temporaryURL: URL, timeout: TimeInterval) {
        self.temporaryURL = temporaryURL
        self.timeout = timeout
    }
    
    public func download(url: URL, in view: UIView, completionHandler: @escaping (URL?, Error?) -> Void) -> Bool {
        guard hud == nil else {
            print("Download in progress, skipping")
            return false
        }
        
        print("Downloading from: \(url)")
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: timeout)
        let task = session.downloadTask(with: request)

        hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud?.mode = .annularDeterminate
        hud?.progressObject = task.progress
//        if let backgroundColor = backgroundColor {
//            hud?.contentColor = backgroundColor
//        }
//        if let tintColor = tintColor {
//            hud?.tintColor = tintColor
//        }

        self.completionHandler = completionHandler
        task.resume()
        return true
    }
}

extension FileDownloader: URLSessionDelegate, URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print(bytesWritten)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("Download failed: \(error)")
            hud?.hide(animated: true)
            hud = nil
            completionHandler?(nil, error)
            completionHandler = nil
            return
        }
        completionHandler = nil
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Download complete!")
        if let url = downloadTask.originalRequest?.url {
            print("\tFrom: \(url)")
        }
        print("\tTo: \(location)")

        let fm = FileManager.default
        do {
            try? fm.removeItem(at: temporaryURL)
            try fm.copyItem(at: location, to: temporaryURL)
        } catch let e {
            print("Failed to copy downloaded file: \(e)")
            return
        }

        hud?.hide(animated: true)
        hud = nil
        completionHandler?(temporaryURL, nil)
        completionHandler = nil
    }
}
