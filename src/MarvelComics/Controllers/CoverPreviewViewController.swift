//
//  CoverPreviewViewController.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import UIKit

class CoverPreviewViewController: LoadableController {

    private var imageCoverPreview = UIImageView(frame: .zero)
    private var buttonDismiss = UIButton(type: .system)
    
    private var comic: Response.Comic!
    
    convenience init(comic: Response.Comic) {
        self.init(initialState: .loading)
        self.comic = comic
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewContent.addSubview(self.buttonDismiss)
        self.buttonDismiss.addTarget(self, action: #selector(dismissTapped(_:)), for: .touchUpInside)
        self.buttonDismiss.tintColor = Theme.Color.Primary.content
        self.buttonDismiss.setTitle(l("Generic.Dismiss"), for: .normal)
        self.buttonDismiss.snp.makeConstraints {
            $0.width.equalTo(100.0)
            $0.height.equalTo(44.0)
            $0.right.equalToSuperview()
            $0.top.equalToSuperview().offset(10.0)
        }
        
        self.imageCoverPreview.contentMode = .scaleAspectFit
        self.viewContent.addSubview(self.imageCoverPreview)
        self.imageCoverPreview.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview().inset(30.0)
            $0.top.equalTo(self.buttonDismiss.snp.bottom).offset(10.0)
        }
        self.viewError.onRetryCallback =  { self.makeRequest() }
        
        self.makeRequest()
    }
    
    func makeRequest() {
        
        if let coverUrl = self.comic.cover {
            
            ImageDownloadManager.shared.loadImage(from: coverUrl, onSuccess: { (_, image) in
                self.imageCoverPreview.image = image
                self.set(state: .content, animated: true)
            }, onError: { (_) in
                self.viewError.labelErrorMessage.text = l("Error.LoadingCover")
                self.set(state: .error, animated: true)
            })
        }
    }
}

// MARK: Action
extension CoverPreviewViewController {
    
    @objc func dismissTapped(_ sender: UIButton?) { self.dismiss(animated: true) }
}


