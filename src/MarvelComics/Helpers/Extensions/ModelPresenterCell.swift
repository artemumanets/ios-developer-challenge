//
//  ModelPresenterCell.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import UIKit

public protocol ModelPresenterCell {
    
    associatedtype Model
    var model: Model? { get set}
}
