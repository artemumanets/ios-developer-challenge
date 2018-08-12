//
//  APIErrorManager.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation
import UIKit

class APIErrorManager: ServiceErrorManager {
    
    static var shared: APIErrorManager = { return APIErrorManager() }()
    
    fileprivate override init() {
        super.init()
    }
    
    class func set(error: ServiceError) -> APIErrorManager {
        shared.set(error: error)
        return shared
    }
    
    class func set(error: ServiceError, arguments: String...) -> APIErrorManager {
        shared.set(error: error, arguments: arguments)
        return shared
    }
    
    override func localizedMessage(for error: ServiceError) -> String {
        switch error {
        case .custom(_, let description): return description ?? ""
        case .noInternetConnection: return l("Error.NoInternetConnection")
        case .httpResponseNotOK(_, _, let response): return (response as? ResponseError)?.formattedDescription ?? l("Error.Generic")
        case .generic(_): return l("Error.Generic")
        default: return l("Error.Generic")
        }
    }
}
