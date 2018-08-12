//
//  RequestBase.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation
import SwiftHash

struct Request {}


extension Request {
    
    class AuthenticationRequest: Codable {
        
        var publicKey: String
        var privateKey: String = ""
        var timeStamp: Int
        var hash: String
        
        init() {
            
            self.publicKey = Configuration.API.publicKey
            self.privateKey = Configuration.API.privateKey
            self.timeStamp = Int(Date().timeIntervalSince1970)
            self.hash = MD5(String(self.timeStamp) + self.privateKey + self.publicKey).lowercased()
        }
        
        private enum CodingKeys: String, CodingKey { case publicKey = "apikey", timeStamp = "ts", hash }
    }
}
