//
//  ErrorCode.swift
//
//  Created by Artem Umanets on 11/07/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation

public struct EmptyError: ParsableResponse {
    
    public init(data: [String : Any]) throws { }
}

public enum ServiceError: Error {
    
    case generic(Error)
    
    case httpResponseNotOK(code: Int, message: String?, error: ParsableResponse?)
    case noInternetConnection
    case mandatoryAttributeNotFound(attribute: String)
    case unexpectedResponseFormat(format: String)
    case custom(error: Error?, description: String?)
    
    var debugDescription: String {
        
        switch self {
        case .generic(let error): return "Generic error occured. Wrapped error description: \(error.localizedDescription)"
        case .noInternetConnection: return "Internet connection is not active."
        case .unexpectedResponseFormat(let expectedFormat): return "Expected response format is \(expectedFormat), but something else was found."
        case .mandatoryAttributeNotFound(let field): return "Tried to parse data, but mandatory field \(field) was not found."
        case .httpResponseNotOK(let statusCode, let description, let error):
            var message = "Response status code was: \(statusCode)"
            if let description = description { message += "\nDescription: \(description)" }
            if let error = error { message += "\nService Response: \(error)" }
            return message
        case .custom(let error, let description):
            var message = "Custom Error Description"
            if let error = error { message += "\n" + error.localizedDescription }
            if let description = description { message += "\n" + description }
            return message
        }
    }
}
