//
//  APIConfigurator.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation

public class APIConfigurator: ServiceConfigurator {
    
    public private(set) static var shared = APIConfigurator()
    
    fileprivate init() { }
    
    public var requestHTTPHeaders: [String : String] {

        return [:]
    }
    
    public var requestEncoding: ServiceRequestEncodingType { return .json }

}
