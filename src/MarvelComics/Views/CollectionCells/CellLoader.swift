//
//  CellLoader.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CellLoader: UICollectionViewCell {
    
    @IBOutlet weak var viewActivityHolder: NVActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = Theme.Color.none
        
        self.viewActivityHolder.color = Theme.Color.Primary.content
        self.viewActivityHolder.type = UI.Components.activityIndicatorStyle
        self.viewActivityHolder.startAnimating()
    }
    
    static func itemSize(in collectionView: UICollectionView) -> CGSize {
        
        let baseHeight = collectionView.bounds.height
        let marginOffset = UI.Layout.ComicsList.margin * 2.0
        let availableHeight = baseHeight - marginOffset
        
        return CGSize(width: 40.0, height: availableHeight)
    }
}

