//
//  UIView+Extensions.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import UIKit

extension UIView {
    
    static func fromNib() -> Self  {
        
        func instanceFromNib<T: UIView>() -> T {
            
            return UINib(nibName: "\(self)", bundle: nil).instantiate(withOwner: nil, options: nil).first as! T
        }
        return instanceFromNib()
    }
}
