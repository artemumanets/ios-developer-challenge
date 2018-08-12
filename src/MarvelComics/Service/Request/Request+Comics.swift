//
//  Request+Comics.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation

extension Request {
    
    struct Comics {
    
        class List: AuthenticationRequest, ServiceRequest {
            
            var endpoint: ServiceEndpoint { return APIEndpoint.listComics }

                    
        }
    }
}
