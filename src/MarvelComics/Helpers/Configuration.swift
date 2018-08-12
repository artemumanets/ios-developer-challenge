//
//  Utils.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation

public final class Configuration {

    public private(set) static var shared = Configuration()
    
    public var configurationName: String = ""
    
    private static let sharedConfiguration = Configuration()
    private lazy var configurations: [String : Any] = {
        if let configurationsData = Bundle.main.infoDictionary?[self.configurationName] as? [String: Any] {
            return configurationsData
        } else {
            Logger.log(message: "Info.plist does not contain configuration key [\(self.configurationName)].")
            return  [:]
        }
    }()
    
    private init() { }
    
    public static func stringFor(key: String) -> String { return Configuration.shared.configurations[key] as! String }
    public static func boolFor(key: String) -> Bool { return Bool(Configuration.shared.configurations[key] as! String) ?? false }
    public static func intFor(key: String) -> Int { return Int(Configuration.shared.configurations[key] as! String) ?? 0 }
    public static func urlFor(key: String) -> URL { return URL(string: Configuration.shared.configurations[key] as! String) ?? URL(string: "/")! }
    
    enum App {
        
        static var environment: Environment = { return Environment(rawValue: Configuration.stringFor(key: "Environment"))! }()
        static var logging = [LoggingFeature]()
    }
    
    enum API {
        
        static var url: URL = { return Configuration.urlFor(key: "APIURL") }()
        static var publicKey: String = { return Configuration.stringFor(key: "APIPublicKey") }()
        static var privateKey: String = { return Configuration.stringFor(key: "APIPrivateKey") }()
    }
}

enum Environment: String {
    
    case dev = "dev"
    case qa = "qa"
    case prod = "prod"
}

enum LoggingFeature {
    
    case external
    case local
}

