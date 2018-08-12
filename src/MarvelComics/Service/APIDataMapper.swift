//
//  APIDataConverter.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation
import UIKit

class APIDataConverter: ServiceDataConverter {
    
    func convert(data: Any?) -> Any? {
        if let data = data as? [String: Any], let dataField = data["data"] {
            return dataField
        }
        return data
    }
}
