//
//  ImageDownloadManager.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation
import UIKit

typealias ImageDownloadOnImageSuccess = (_ url: URL, _ image: UIImage) -> Void
typealias ImageDownloadOnImageError = (_ url: URL) -> Void
typealias ImageDownloadOnFinally = () -> Void
class ImageDownloadManager {
    
    private init() {}
    private var imageCache = [String: UIImage]()
    
    static var shared: ImageDownloadManager = { return ImageDownloadManager() }()
    
    func loadImage(from url: URL, onSuccess: @escaping ImageDownloadOnImageSuccess, onError: @escaping ImageDownloadOnImageError, onFinally: @escaping ImageDownloadOnFinally = {}) {
        
        if let image = self.imageCache[url.absoluteString] {
            onSuccess(url, image)
            onFinally()
        } else {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                DispatchQueue.main.async {
                    guard let data = data, error == nil, let image = UIImage(data: data) else {
                        onError(url)
                        onFinally()
                        return
                    }

                    self.imageCache[url.absoluteString] = image
                    onSuccess(url, image)
                    onFinally()
                }
            }.resume()
        }
    }
}
