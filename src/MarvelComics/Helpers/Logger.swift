//
//  Logger.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation

public class Logger {
    
    static var enabled: Bool = false
    
    private init() {}
    
    public static func log(message: String, group: String? = nil) {
        if Logger.enabled {
            var finalMessage = message
            if let group = group {
                finalMessage = "[\(group)] \(finalMessage)"
            }
            print(finalMessage)
        }
    }
}
