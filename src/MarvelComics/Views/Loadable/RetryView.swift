//
//  RetryView.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class RetryView: UIView {
    
    @IBOutlet weak var labelErrorMessage: UILabel!
    @IBOutlet weak var buttonRetry: UIButton!
    
    var onRetryCallback: CallbackSimple?
    
    static func create() -> RetryView {
        
        let retryView = RetryView.fromNib()
        return retryView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.labelErrorMessage.set(color: Theme.Color.Primary.content, font: Theme.Font.h3.medium)
//        self.buttonRetry.configure(as: .lightContentPrimary, title: "Global.Reload".localized)
    }
}

// MARK: Action
extension RetryView {
    
    @IBAction func retryTapped(sender: UIButton?) {
        self.onRetryCallback?()
    }
}
