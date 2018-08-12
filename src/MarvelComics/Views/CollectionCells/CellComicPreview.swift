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
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    typealias Model = Response.Comic

    var model: Response.Comic? {
        didSet {
            guard let model = self.model, let thumbnailURL = model.thumbnail else { return }
            self.imageView.image = nil
            
            self.startLoading {
                ImageDownloadManager.shared.loadImage(from: thumbnailURL, onSuccess: { (url, image) in
                    self.imageView.backgroundColor = Theme.Color.none
                    self.imageView.image = (url == self.model?.thumbnail ? image : nil)
                    self.imageView.contentMode = .scaleAspectFill
                    self.stopLoading()
                }, onError: { (url) in
                    self.imageView.backgroundColor = UIColor.blue
//                    self.imageView.image = #imageLiteral(resourceName: "NoImagePlaceholder")
//                    self.imageView.contentMode = .center
                    self.stopLoading()
                })
            }
        }
    }
    
    func startLoading(completion: CallbackSimple? = nil) {
        ActionAnimation(duration: UI.Animation.fast, options: .curveEaseOut, animation: {
            self.imageView.alpha = 0.0
            self.activityLoader.alpha = 1.0
        }).start(animated: true, onCompletion: { completion?() })
    }
    
    func stopLoading() {
        ActionAnimation(duration: UI.Animation.normal, options: .curveEaseOut, animation: {
            self.imageView.alpha = 1.0
            self.activityLoader.alpha = 0.0
        }).start()
    }
}

