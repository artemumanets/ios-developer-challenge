//
//  Response+Comics.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation

extension Response {
    
    struct Comic: ParsableResponse {
        
        let id: Int
        let title: String
        let issueNumber: Int
        
        let thumbnail: URL?
        
        
        init(data: [String : Any]) throws {
            
            self.id = try data.value(forKey: "id")
            self.title = try data.value(forKey: "title")
            self.issueNumber = try data.value(forKey: "issueNumber")
            
            if let path: String = data.optionalValue(forPath: "thumbnail.path"), let ext: String = data.optionalValue(forPath: "thumbnail.extension") {
                self.thumbnail = APIUtils.optionalURL(from: "\(path).\(ext)")
            } else {
                self.thumbnail = nil
            }
        }
    }
}
