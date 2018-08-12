//
//  Date+Extension.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation
import UIKit

struct APIUtils {
    
    static func dateFrom(timestamp: Double) -> Date {
        let date = Date(timeIntervalSince1970: timestamp)
        return date
    }
    
    static func optionalDateFrom(timestamp: Double?) -> Date? {
        guard let dateTimestamp = timestamp else { return nil }
        return APIUtils.dateFrom(timestamp: dateTimestamp)
    }
    
    static func URL(from string: String) -> URL {
        return UIKit.URL(string: string)!
    }
    
    static func optionalURL(from string: String?) -> URL? {
        if let unwrappedString = string { return APIUtils.URL(from: unwrappedString) }
        return nil
    }
    
    static func array<I,T>(from data: [I]?, transform: (_ input: I) throws -> T) throws -> [T] {
        var array = [T]()
        guard let unwrappedData = data else { return array }
        
        array = try unwrappedData.map { try transform($0) }
        return array
    }
    
    static func double(from string: String?) -> Double? {
        guard let string = string else { return nil }
        
        return Double(string)
    }
}
