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
            
            static let background = UIColor(hex: 0x1E5190)
            static let content = UIColor(hex: 0xFFFFFF)
            static let subContent = UIColor(hex: 0xFFFFFF).withAlphaComponent(0.5)
            
            static let accent = UIColor(hex: 0x5F83AF)
            
            static let error = UIColor(hex: 0xE02A2A)
        }
    }
    
    enum Font {
        
        struct h3: ThemeFont { static var size: CGFloat = 15.0 }
        struct h4: ThemeFont { static var size: CGFloat = 14.0 }
        struct h5: ThemeFont { static var size: CGFloat = 13.0 }
        struct h6: ThemeFont { static var size: CGFloat = 12.0 }
        struct h7: ThemeFont { static var size: CGFloat = 11.0 }
        struct h8: ThemeFont { static var size: CGFloat = 10.0 }
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
