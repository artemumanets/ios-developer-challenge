//
//  Global.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation

typealias CallbackSimple = () -> ()

func l(_ localized: String) -> String {
    return NSLocalizedString(localized, comment: "")
}
