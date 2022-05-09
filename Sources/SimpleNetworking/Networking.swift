//
//  File.swift
//  
//
//  Created by Ralph Schnalzenberger on 09.05.22.
//

import Foundation

public protocol Networking: AnyObject {
    @available(iOS 15.0.0, *)
    @available(macOS 12.0.0, *)
    func fetch<R: Request>(request: R) async throws -> R.Output
    
    var delegate: NetworkingDelegate? { get set }
}
