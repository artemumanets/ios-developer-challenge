//
//  InitializationManager.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation
import UIKit

enum InitializationComponent {
    
    case service
    case appearence
    case logging([LoggingFeature])
}

class InitializationManger {
    
    class func initialize(components: [InitializationComponent], launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
        Configuration.shared.configurationName = "MarvelComics"
        
        components.forEach {
            
            switch $0 {
            case .service: Service.setConfigurator(configurator: APIConfigurator.shared)
            case .appearence:
                UINavigationBar.appearance().tintColor = Theme.Color.Primary.content
                UINavigationBar.appearance().barTintColor = nil
                UINavigationBar.appearance().backIndicatorImage = #imageLiteral(resourceName: "ButtonBackNavigation")
                UINavigationBar.appearance().backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "ButtonBackNavigation")
            case .logging(let loggingFeature):

                if loggingFeature.contains(.local) { Logger.enabled = (Configuration.App.environment == .dev) }
            }
        }
    }
}
