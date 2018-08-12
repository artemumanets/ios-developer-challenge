//
//  LoadableProtocol.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import UIKit

enum ViewControllerState {
    case loading
    case error
    case content
    case noContent
}

protocol LoadableProtocol: class {
    
    var viewMain: UIView { get set }

    var viewContent: UIView { get set }
    var viewNoContent: NoContentView? { get set }
    var viewLoader: LoaderView { get set }
    var viewError: RetryView { get set }
    
    var state: ViewControllerState { get set }
}

extension LoadableProtocol where Self: UIViewController {
    
    var errorCallback: APIErrorCallbackWrapper {
        return { (error) in
            self.viewError.labelErrorMessage.text = APIErrorManager.shared.localizedMessage(for: error)
            self.set(state: .error, animated: true)
        }
    }
    
    func setupLoadableLayout() {
        
        self.view.addSubview(self.viewMain)
        self.viewMain.snp.makeConstraints { $0.leading.trailing.top.bottom.equalToSuperview() }
        
        if let viewNoContent = self.viewNoContent {
            self.viewMain.addSubview(viewNoContent)

            viewNoContent.snp.makeConstraints {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
                $0.leading.trailing.bottom.equalToSuperview()
            }
            viewNoContent.snp.makeConstraints { $0.leading.trailing.bottom.top.equalToSuperview() }
        }
        
        self.viewMain.addSubview(self.viewContent)
        self.viewContent.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        self.viewMain.addSubview(self.viewLoader)
        self.viewLoader.snp.makeConstraints { $0.leading.trailing.bottom.top.equalToSuperview() }
        
        self.viewMain.addSubview(self.viewError)
        self.viewError.snp.makeConstraints { $0.leading.trailing.bottom.top.equalToSuperview() }
    }
    
    func set(state: ViewControllerState, animated: Bool) {
        
        guard self.state != state else { return }
        
        self.state = state
        let transition = {
            if self.state == .loading {
                self.viewContent.alpha = 0.0
                self.viewLoader.alpha = 1.0
                self.viewError.alpha = 0.0
                self.viewNoContent?.alpha = 0.0
            } else if self.state == .error {
                self.viewContent.alpha = 0.0
                self.viewLoader.alpha = 0.0
                self.viewError.alpha = 1.0
                self.viewNoContent?.alpha = 0.0
            } else if self.state == .content {
                self.viewContent.alpha = 1.0
                self.viewLoader.alpha = 0.0
                self.viewError.alpha = 0.0
                self.viewNoContent?.alpha = 0.0
            } else if self.state == .noContent {
                self.viewContent.alpha = 0.0
                self.viewLoader.alpha = 0.0
                self.viewError.alpha = 0.0
                self.viewNoContent?.alpha = 1.0
            }
        }
        
        ActionAnimation(duration: UI.Animation.normal, options: .curveEaseInOut, animation: transition).start(animated: animated)
    }
}
