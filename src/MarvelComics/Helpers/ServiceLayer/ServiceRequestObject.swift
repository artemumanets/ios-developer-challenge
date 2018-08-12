//
//  ServiceRequestObject.swift
//
//  Created by Artem Umanets on 12/09/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation
import Alamofire

public class ServiceRequestObject {
    
    private var request: DataRequest?
    
    init(request: DataRequest?) {
        self.request = request;
    }
    
    func cancel() {
        self.request?.cancel()
    }
    
    func set(request: DataRequest?) {
        self.request = request
    }
}
