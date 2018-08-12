//
//  Response.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation

struct Response {
    
    struct EmptyBody: ParsableResponse {
        
        init(data: [String : Any]) throws { }
    }
}

struct ResponseError: ParsableResponse, CustomStringConvertible {
    var message: String
    var statusCode: Int
    var errors: [String: [String]]
    
    var description: String {
        return "Status Code: \(self.statusCode)" + "\nMessage: \(self.message)" + "\nErrors: \(self.errors.map { return "\($0.key) - \($0.value.description)" })"
    }
    
    var formattedDescription: String {
        var message: String = self.message
        self.errors.forEach { (key, value) in
            value.forEach {
                message += "\n\($0)"
            }
        }
        return message
    }
    
    init(data: [String : Any]) throws {
        self.message = try data.value(forKey: "message")
        self.statusCode = try data.value(forKey: "status_code")
        self.errors = data["errors"] as? [ String: [String]] ?? [String: [String]]()
    }
}

