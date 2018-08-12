//
//  DataSource.swift
//  MarvelComics
//
//  Created by Artem Umanets on 12/08/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation

typealias APIErrorCallbackWrapper = (_ error: ServiceError) -> ()
typealias APISuccessCallbackWrapper<T> = (_ response: T) -> ()

struct DataSource {
    
    static func response<T: ParsableResponse>(with request: ServiceRequest, onSuccess: @escaping APISuccessCallbackWrapper<T>, onError: @escaping APIErrorCallbackWrapper, onFinally: @escaping APIFinallyCallback = {}) {
        DataSource.response(with: request, onSuccess: { (response: T, type: T.Type) in onSuccess(response) }, onError: onError, onFinally: onFinally)
    }
    
    static func response<T: ParsableResponse>(with request: ServiceRequest, onSuccess: @escaping APISuccessCallbackWrapper<[T]>, onError: @escaping APIErrorCallbackWrapper, onFinally: @escaping APIFinallyCallback = {}) {
        DataSource.response(with: request, onSuccess: { (response: [T], type: T.Type) in onSuccess(response) }, onError: onError, onFinally: onFinally)
    }
    
    private static func response<T: ParsableResponse, X>(with request: ServiceRequest, onSuccess: @escaping APISuccessCallback<T, X>, onError: @escaping APIErrorCallbackWrapper, onFinally: @escaping APIFinallyCallback = {}) {
        
        Logger.log(message: request.debugDescription)
        
        Service.getResponse(request: request, converter: APIDataConverter(), onSuccess: { (response: X, type: T.Type) in
            onSuccess(response, type)
        }, onError: { (error, type: ResponseError.Type) in
            let wrappedRequestCallback = { DataSource.response(with: request, onSuccess: onSuccess, onError: onError, onFinally: onFinally) }
            checkSpecificErrorStates(request: request, error: error, wrappedRequest: wrappedRequestCallback, onError: onError)
        }, onFinally: onFinally)
    }
    
    private static func checkSpecificErrorStates(request: ServiceRequest, error: ServiceError, wrappedRequest: @escaping CallbackSimple, onError: @escaping APIErrorCallbackWrapper) {
        
        onError(error)
        
//        switch error {
//        case .noInternetConnection:
//            
//            let noInternetDialog = DialogNoInternet.create(reloadAction: wrappedRequest)
//            noInternetDialog.show()
//        case .httpResponseNotOK(let responseCode, _, _):
//            guard !(request is Request.RenewToken) else {
//                NotificationManager.shared.notify(event: Config.Listener.sessionExpiredEvent, argument: true)
//                return
//            }
//            if responseCode == 401 && request.authenticationRequired {
//                
//                if let token = APIConfigurator.shared.authorizationToken {
//                    DataSource.response(with: Request.RenewToken(token: token), onSuccess: { (response: Response.Login) in
//                        APIConfigurator.shared.authorizationToken = response.token
//                        wrappedRequest()
//                    }, onError: { (error) in
//                        NotificationManager.shared.notify(event: Config.Listener.sessionExpiredEvent, argument: true)
//                    })
//                } else {
//                    NotificationManager.shared.notify(event: Config.Listener.sessionExpiredEvent, argument: true)
//                }
//            } else {
//                onError(error)
//            }
//        default:
//            onError(error)
//        }
    }
}
