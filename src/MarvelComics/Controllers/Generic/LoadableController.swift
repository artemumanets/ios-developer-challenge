//
//  LoadableController.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import UIKit
import SnapKit

class LoadableController: GenericViewController, LoadableProtocol {
   
    var viewMain = UIView(frame: .zero)
    var viewContent = UIView(frame: .zero)
    var viewLoader: LoaderView = .create(color: Theme.Color.Primary.background)
    var viewError: RetryView = .create()
    
    var state: ViewControllerState = .content
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(initialState: ViewControllerState) {
        super.init(nibName: nil, bundle: nil)
        self.set(state: initialState, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLoadableLayout()
        
        self.viewMain.backgroundColor = Theme.Color.Primary.background
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Background"))
        self.viewMain.addSubview(imageView)
        self.viewMain.sendSubview(toBack: imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
