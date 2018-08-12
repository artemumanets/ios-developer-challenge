//
//  CellComicPreview.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import UIKit

class CellComicPreview: UICollectionViewCell, ModelPresenterCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    typealias Model = Response.Comic

    var model: Response.Comic? {
        didSet {
            guard let model = self.model, let thumbnailURL = model.thumbnail else {
                self.imageView.image = #imageLiteral(resourceName: "ComicThumbnailUnavailable")
                return
            }
            if let cachedImage = ImageDownloadManager.shared.cachedImage(url: thumbnailURL) {
                self.imageView.image = cachedImage
            } else {
                self.startLoading {
                    ImageDownloadManager.shared.loadImage(from: thumbnailURL, onSuccess: { (url, image) in
                        self.imageView.image = (url == self.model?.thumbnail ? image : #imageLiteral(resourceName: "ComicThumbnailUnavailable"))
                        self.stopLoading()
                    }, onError: { (url) in
                        self.imageView.image = #imageLiteral(resourceName: "ComicThumbnailUnavailable")
                        self.stopLoading()
                    })
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = Theme.Color.Primary.background
        self.imageView.contentMode = .scaleAspectFill
    }
    
    func startLoading(completion: CallbackSimple? = nil) {
        ActionAnimation(duration: UI.Animation.fast, options: .curveEaseOut, animation: {
            self.imageView.alpha = 0.0
        }).start(animated: true, onCompletion: { completion?() })
    }
    
    func stopLoading() {
        ActionAnimation(duration: UI.Animation.normal, options: .curveEaseOut, animation: {
            self.imageView.alpha = 1.0
        }).start()
    }
    
    static func itemSize(in collectionView: UICollectionView) -> CGSize {
        
        let baseHeight = collectionView.bounds.height
        let marginOffset = UI.Layout.ComicsList.margin * 2.0
        let availableHeight = (baseHeight - marginOffset) - UI.Layout.ComicsList.spaceBetweenItens * CGFloat((UI.Layout.ComicsList.numberOfRows - 1))
        let itemHeight = availableHeight / CGFloat(UI.Layout.ComicsList.numberOfRows)
        return UI.Layout.ComicsList.imageSize(for: itemHeight)
    }
}

