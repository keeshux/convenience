//
//  ReadonlyWebServices.swift
//  Convenience
//
//  Created by Davide De Rosa on 11/20/19.
//  Copyright © 2019 Davide De Rosa. All rights reserved.
//

import Foundation
import SwiftyBeaver

private let log = SwiftyBeaver.self

public class ReadonlyWebServices {
    private let queue: DispatchQueue
    
    public var timeout: TimeInterval

    public convenience init() {
        self.init(queue: .main)
    }

    public init(queue: DispatchQueue) {
        self.queue = queue
        timeout = 10.0
    }
    
    public func get(_ endpoint: Endpoint) -> URLRequest {
        return URLRequest(url: endpoint.url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: timeout)
    }
    
    public func parse<T: Decodable>(_ type: T.Type, request: URLRequest, completionHandler: @escaping (Response<T>?, Error?) -> Void) {
        log.debug("GET \(request.url!)")
        log.debug("Request headers: \(request.allHTTPHeaderFields?.description ?? "")")

        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                log.error("Error (response): \(error?.localizedDescription ?? "nil")")
                self.queue.async {
                    completionHandler(nil, error)
                }
                return
            }

            let statusCode = httpResponse.statusCode
            log.debug("Response status: \(statusCode)")
            if let responseHeaders = httpResponse.allHeaderFields as? [String: String] {
                log.debug("Response headers: \(responseHeaders)")
            }

            // 304: cache hit
            if statusCode == 304 {
                log.debug("Response is cached")
                self.queue.async {
                    completionHandler(Response(value: nil, lastModifiedString: nil, isCached: true), nil)
                }
                return
            }

            // 200: cache miss
            let value: T
            let lastModifiedString: String?
            guard statusCode == 200, let data = data else {
                log.error("Error (network): \(error?.localizedDescription ?? "nil")")
                self.queue.async {
                    completionHandler(nil, error)
                }
                return
            }
            do {
                value = try JSONDecoder().decode(type, from: data)
            } catch let e {
                log.error("Error (parsing): \(e)")
                self.queue.async {
                    completionHandler(nil, error)
                }
                return
            }
            lastModifiedString = httpResponse.allHeaderFields["Last-Modified"] as? String

            let response = Response(value: value, lastModifiedString: lastModifiedString, isCached: false)
            self.queue.async {
                completionHandler(response, nil)
            }
        }.resume()
    }
}
