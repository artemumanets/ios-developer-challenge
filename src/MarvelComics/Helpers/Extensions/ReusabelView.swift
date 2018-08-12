//
//  ReusableView.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import UIKit

public protocol ReusableView: class {
    
    static var reuseIdentifier: String { get }
    static var nib: UINib { get }
}

public extension ReusableView {
    
    static var reuseIdentifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: self.reuseIdentifier, bundle: nil) }
}
