//
//  ServiceEndpoint.swift
//
//  Created by Artem Umanets on 12/07/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation

public typealias EndpointInfo = (method: EndpointHTTPMethod, endpoint: String)

public protocol ServiceEndpoint {
    
    var info: EndpointInfo { get }
}

public enum EndpointHTTPMethod: String {
    
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
    case options = "OPTIONS"
    case head    = "HEAD"
    case patch   = "PATCH"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
