//
//  Config.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

enum UI {
    
    enum Layout {
        
        enum ComicsList {
            
            static let numberOfRows: Int = 4
            static let spaceBetweenItens: CGFloat = 10.0
            static let margin: CGFloat = 20.0
            
            static func imageSize(for height: CGFloat) -> CGSize { return CGSize(width: height * 560.0 / 820.0, height: height) }
        }
    }
    
    enum Components {
        
        static let activityIndicatorStyle: NVActivityIndicatorType = .ballTrianglePath
    }
    
    enum Animation {
        
        static let fast: Double = 0.25
        static let normal: Double = 0.35
    }
}
