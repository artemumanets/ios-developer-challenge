//
//  DataSource.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation

typealias APIErrorCallbackWrapper = (_ error: ServiceError) -> ()
typealias APISuccessCallbackWrapper<T> = (_ response: T) -> ()

struct DataSource {
    
}
