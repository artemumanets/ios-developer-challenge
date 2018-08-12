//
//  ServiceRequest.swift
//
//  Created by Artem Umanets on 14/05/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation

public typealias QueryStringParameters = [String: String]

public protocol ServiceRequest: Codable {
    
    var endpoint: ServiceEndpoint { get }
    var url: String { get }
    var body: [String: Any] { get }
    
    var HTTPHeaders: [String: String]? { get }
    var excludedHTTPHeaders: [String]? { get }
    var encoding: ServiceRequestEncodingType? { get }
}

public extension ServiceRequest {
    
    var body: [String : Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [String: Any]() }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] } ?? [String: Any]()
    }
    
    var HTTPHeaders: [String: String]? { return nil }
    var excludedHTTPHeaders: [String]? { return nil }
    var encoding: ServiceRequestEncodingType? { return nil }
    
    var debugDescription: String {
        
        var desc = "[\(self.endpoint.info.method.rawValue)] \(self.url)"
        if self.body.count > 0 { desc += "\nBody:" }
        self.body.forEach { desc += "\n\t\($0.key): \($0.value)" }
        return desc
    }
}

public struct MultipartDataItem {
    var name: String
    var fileName: String
    var mimeType: String
    var data: Data
}

public protocol MultipartRequest: ServiceRequest {
    
    var data: [MultipartDataItem]? { get set }
}

