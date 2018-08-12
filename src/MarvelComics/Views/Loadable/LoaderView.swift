//
//  TutorialEntryView.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoaderView: UIView {
    
    @IBOutlet weak var viewActivityHolder: NVActivityIndicatorView!
    
    static func create(color: UIColor) -> LoaderView {
        
        let loader = LoaderView.fromNib()
        loader.viewActivityHolder.color = UIColor.black // TODO: Change
        loader.viewActivityHolder.type = UI.Components.activityIndicatorStyle
        loader.viewActivityHolder.startAnimating()
        return loader
    }
}
