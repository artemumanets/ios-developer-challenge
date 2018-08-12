//
//  Request+Comics.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation
import SwiftHash

extension Request {
    
    struct Comics {
    
        class List: ServiceRequest {
            
            var endpoint: ServiceEndpoint { return APIEndpoint.listComics }
            
            private var privateKey: String = ""
            var publicKey: String
            var timeStamp: Int
            var hash: String
            
            let pageSize: Int
            let offset: Int
            let format: String = "comic"
            let formatType: String = "comic"
            let noVariants: Bool = true
            
            init(pageSize: Int, offset: Int) {
                self.pageSize = pageSize
                self.offset = offset
                
                self.publicKey = Configuration.API.publicKey
                self.privateKey = Configuration.API.privateKey
                self.timeStamp = Int(Date().timeIntervalSince1970)
                self.hash = MD5(String(self.timeStamp) + self.privateKey + self.publicKey).lowercased()
            }
            
            private enum CodingKeys: String, CodingKey { case pageSize = "limit", offset, publicKey = "apikey", timeStamp = "ts", hash, format, formatType, noVariants }
        }
    }
}
