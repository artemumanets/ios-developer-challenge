//
//  ServiceDataConverter.swift
//
//  Created by Artem Umanets on 17/07/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation

public protocol ServiceDataConverter {
    
    func convert(data: Any?) -> Any?
}
