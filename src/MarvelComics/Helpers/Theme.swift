//
//  Theme.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation
import UIKit

struct Theme {
    
    enum Color {
        
        static let none = UIColor.clear
        
        enum Primary {
            
            static let background = UIColor(hex: 0xFFFFFF)
            static let content = UIColor(hex: 0xFFFFFF)
        }
        
        enum Error {
            static let background = UIColor(hex: 0x000000)
            static let content = UIColor(hex: 0xffffff)
        }
    }
    
    enum Font {
        
        struct content: ThemeFont { static var size: CGFloat = 15.0 }
    }
}


protocol ThemeFont {
    static var size: CGFloat { get }
}

extension ThemeFont {
    
    static var regular: UIFont { return UIFont.regular(ofSize: size) }
    static var medium: UIFont { return UIFont.medium(ofSize: size) }
}

fileprivate extension UIFont {
    
    class func regular(ofSize size: CGFloat) -> UIFont { return UIFont(name: "Avenir-Book", size: size)! }
    class func medium(ofSize size: CGFloat) -> UIFont { return UIFont(name: "Avenir-Medium", size: size)! }
    class func bold(ofSize size: CGFloat) -> UIFont { return UIFont(name: "Avenir-Black", size: size)! }
}
