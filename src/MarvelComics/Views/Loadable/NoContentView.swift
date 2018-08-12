//
//  NoContentView.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import UIKit

class NoContentView: UIView {
    
    @IBOutlet weak var labelMessage: UILabel!
    
    static func create() -> NoContentView {
        
        let retryView = NoContentView.fromNib()
        return retryView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // TODO: Change Color
        self.labelMessage.set(color: UIColor.red, font: Theme.Font.h3.medium)
    }
}
