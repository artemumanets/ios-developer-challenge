//
//  Response+Comics.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation

extension Response {
    
    struct Paginated<P: ParsableResponse>: ParsableResponse {
        
        let offset: Int
        let count: Int
        let limit: Int
        let total: Int
        let result: [P]
        
        init(data: [String : Any]) throws {
            self.offset = try data.value(forKey: "offset")
            self.count = try data.value(forKey: "count")
            self.limit = try data.value(forKey: "limit")
            self.total = try data.value(forKey: "total")
            self.result = try APIUtils.array(from: data.optionalValue(forPath: "results") as [[String: Any]]?, transform: { try P(data: $0) })
        }
    }
}
