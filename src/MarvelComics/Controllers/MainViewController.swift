//
//  ViewController.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import UIKit

class MainViewController: LoadableDynamicViewController {

    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    init() {
        super.init(initialState: .loading)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.makeRequest()
    }
    
    func makeRequest() {
        self.state = .loading
        DataSource.response(with: Request.Comics.List(), onSuccess: { (response: Response.Paginated<Response.Comic>) in
            
            print("Response: \(response)")
            self.state = .content
        }, onError: self.errorCallback)
    }
}

