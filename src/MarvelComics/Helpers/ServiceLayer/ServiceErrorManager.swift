//
//  ServiceErrorManager.swift
//
//  Created by Artem Umanets on 12/07/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation

class ServiceErrorManager {

    private var lastError: ServiceError?
    private var formatStringArguments: [String]?
    
    func set(error: ServiceError) {
        self.lastError = error
    }
    
    func set(error: ServiceError, arguments: [String]) {
        self.lastError = error
        self.formatStringArguments = arguments
    }
    
    func text() -> String {
        var errorMessage = ""
        if let error = self.lastError {
            self.lastError = nil
            errorMessage = self.localizedMessage(for: error)
            if let arguments = self.formatStringArguments {
                errorMessage = self.getFullErrorMessage(from: errorMessage, arguments: arguments)
            }
        }
        return errorMessage
    }
    
    func localizedMessage(for error: ServiceError) -> String {
        fatalError("Override this is your ServiceErrorManager subclass")
    }
    
    private func getFullErrorMessage(from message: String, arguments: [String]) -> String {
        var fullMessage = message
        var remainingArguments = arguments
        while remainingArguments.count > 0 && fullMessage.contains("%@") {
            let arg = remainingArguments.removeFirst()
            fullMessage = fullMessage.replacingFirstOccurrence(of: "%@", with: arg)
        }
        return fullMessage
    }
}
