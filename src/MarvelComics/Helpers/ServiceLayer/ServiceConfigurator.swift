//
//  Service.swift
//
//  Created by Artem Umanets on 11/07/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation

public enum ServiceRequestEncodingType {
    
    case url, json
}

public protocol ServiceConfigurator {
    
    var requestHTTPHeaders: [String: String] { get }
    var requestEncoding: ServiceRequestEncodingType { get }
}
