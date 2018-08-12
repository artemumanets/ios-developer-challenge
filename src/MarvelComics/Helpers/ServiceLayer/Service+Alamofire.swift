//
//  Dicionary+Extensions.swift
//
//  Created by Artem Umanets on 12/07/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation
import Alamofire

extension EndpointHTTPMethod {
    
    var alamofireHttpMethod: HTTPMethod {
        switch self {
        case .get: return .get
        case .post: return .post
        case .put: return .put
        case .delete: return .delete
        case .options: return .options
        case .head: return .head
        case .patch: return .patch
        case .trace: return .trace
        case .connect: return .connect
        }
    }
}


extension ServiceRequestEncodingType {
    
    var almofireEncodingType: ParameterEncoding {
        switch self {
        case .url: return URLEncoding.default
        case .json: return JSONEncoding.default
        }
    }
}


