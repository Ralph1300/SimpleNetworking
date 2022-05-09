//
//  NetworkingDelegate.swift
//  
//
//  Created by Ralph Schnalzenberger on 09.05.22.
//

import Foundation

public protocol NetworkingDelegate: AnyObject {
    func headers(for networking: Networking) -> [String: String]
}

public extension Networking {
    func headers(for networking: Networking) -> [String: String] {
        return [:]
    }
}
