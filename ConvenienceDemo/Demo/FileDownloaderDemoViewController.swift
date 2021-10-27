//
//  FileDownloaderDemoViewController.swift
//  ConvenienceDemo
//
//  Created by Davide De Rosa on 9/9/19.
//  Copyright © 2021 Davide De Rosa. All rights reserved.
//

#if canImport(UIKit)
import UIKit
#endif
import Convenience

class FileDownloaderDemoViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView?
    
    private var downloader: FileDownloader?
    
    private let imageURL = URL(string: "https://mdbootstrap.com/img/Others/documentation/2.jpg")!
    
    @IBAction private func startDownloading() {
        let temp = FileManager.default.temporaryDirectory.appendingPathComponent("download.tmp")
        downloader = FileDownloader(temporaryURL: temp, timeout: 5.0)
        _ = downloader?.download(url: imageURL, in: view) { [weak self] in
            self?.handleDownload(file: $0, error: $1)
        }
    }
    
    private func handleDownload(file: URL?, error: Error?) {
        guard let file = file else {
            print(error!)
            return
        }
        guard let image = UIImage(contentsOfFile: file.path) else {
            return
        }
        imageView?.image = image
    }
}
