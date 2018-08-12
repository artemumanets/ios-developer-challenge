//
//  APIEndpoint.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation

enum APIEndpoint: ServiceEndpoint {
    
    case listComics

    var info: EndpointInfo {
        switch self {
        case .listComics: return (.get, "v1/public/comics")
        }
    }
}

extension ServiceRequest {
    
    var url: String {
        return "\(Configuration.API.url)/\(self.endpoint.info.endpoint)"
    }
}
