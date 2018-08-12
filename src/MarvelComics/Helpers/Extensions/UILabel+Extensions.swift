//
//  UILabel+Extensions.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import UIKit

extension UILabel {
    
    func set(color: UIColor, font: UIFont, text: String? = nil) {
        self.textColor = color
        self.font = font
        if let text = text { self.text = text }
    }
}
