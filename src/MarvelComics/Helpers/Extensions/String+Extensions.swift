//
//  String+Extensions.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation

extension String {
    
    func replacingFirstOccurrence(of string: String, with replacement: String) -> String {
        guard let range = self.range(of: string) else { return self }
        return self.replacingCharacters(in: range, with: replacement)
    }
}
