//
//  Request.swift
//  
//
//  Created by Ralph Schnalzenberger on 03.11.21.
//

import Foundation
import UIKit

public protocol Request {
    associatedtype Output
    
    var method: HTTPMethod { get }
    var url: URL { get }
    
    func decode(_ data: Data) throws -> Output
}

extension Request where Output: Decodable {
    public func decode(_ data: Data) throws -> Output {
        let decoder = JSONDecoder()
        return try decoder.decode(Output.self, from: data)
    }
}

extension Request where Output: UIImage {
    public func decode(_ data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw NetworkManager.Error.cannotParse
        }
        return image
    }
}
