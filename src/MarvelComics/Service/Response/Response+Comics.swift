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
        
        var teste: String = ""
        
        init(data: [String : Any]) throws {
            
        }
    }
}
