//
//  Dicionary+Extensions.swift
//
//  Created by Artem Umanets on 12/07/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation

public extension Dictionary {
    
    var queryString: String {

        return "?" + self.compactMap { "\($0)=\($1)" }.joined(separator: "&")
    }
        
    func value<T>(forKey key: Key) throws -> T {

        if let value: T = self.optionalValue(forKey: key) {
            return value
        } else {
            throw ServiceError.mandatoryAttributeNotFound(attribute: String(describing: key))
        }
    }
    
    func value<T>(forPath path: String, delimiter: String = ".") throws -> T {
        
        if let value: T = self.optionalValue(forPath: path, delimiter: delimiter) {
            return value
        } else {
            throw ServiceError.mandatoryAttributeNotFound(attribute: String(describing: path))
        }
    }
    
    func optionalValue<T>(forKey key: Key) -> T? {
        
        return self[key] as? T
    }
    
    func optionalValue<T>(forPath path: String, delimiter: String = ".") -> T? {
        guard path.contains(delimiter) else {
            let value: T? = self.optionalValue(forKey: path as! Key)
            return value
        }
        
        var pathComponents = path.components(separatedBy: delimiter)
        var currentRoot: [Key: Value]? = self
        
        let lastPathComponent = pathComponents.removeLast()
        for pathComponent in pathComponents {
            currentRoot = currentRoot?[pathComponent as! Key] as? [Key: Value]
        }
        return currentRoot?[lastPathComponent as! Key] as? T
    }

    mutating func merge(dict: [Key: Value]) {
    
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
