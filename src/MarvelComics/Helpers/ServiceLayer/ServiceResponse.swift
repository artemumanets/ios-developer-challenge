//
//  Response.swift
//
//  Created by Artem Umanets on 14/05/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation

public protocol ParsableResponse {
    
    init(data: [String: Any]) throws
    init?(data: [String: Any]?) throws
}

public extension ParsableResponse {
    
    init?(data: [String: Any]?) throws {
        guard let unwrappedData = data else { return nil }
        try self.init(data: unwrappedData)
    }
}

struct ServiceDataResponse<T: ParsableResponse>: ParsableResponse {
    
    let data: T
    
    init(data: [String: Any]) throws {
        
        self.data = try T(data: data)
    }
}
