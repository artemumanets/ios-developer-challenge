//
//  Service.swift
//
//  Created by Artem Umanets on 11/07/2018.
//  Copyright © 2018 Seedrop. All rights reserved.
//

import Foundation
import Alamofire
import SystemConfiguration

public typealias APISuccessCallback<T, X> = (_ result: X, _ type: T.Type) -> Void
public typealias APIErrorCallback<E: ParsableResponse> = (_ error: ServiceError, _ type: E.Type) -> Void
public typealias APIFinallyCallback = () -> Void
fileprivate typealias APIResponseMapper<T> = (_ jsonResponse: Any?, _ responseType: T.Type) throws -> Any

public class Service {

    private static var serviceConfigurator: ServiceConfigurator? = nil
    
    class func setConfigurator(configurator: ServiceConfigurator) {
        Service.serviceConfigurator = configurator
    }
    
    @discardableResult class func getResponse<T: ParsableResponse, E: ParsableResponse, X>(request: ServiceRequest,
                                                                                           converter: ServiceDataConverter? = nil,
                                                                                           onSuccess: @escaping APISuccessCallback<T, X>,
                                                                                           onError: @escaping APIErrorCallback<E>,
                                                                                           onFinally: @escaping APIFinallyCallback) -> ServiceRequestObject {

        let parser: APIResponseMapper<T> = Service.dataParser(for: T.self, responseObjectType: X.self)

        var requestWrapper: ServiceRequestObject!
        if let multiPartRequest = request as? MultipartRequest {
            requestWrapper = self.makeMultipartRequest(request: multiPartRequest, converter: converter, responseParser: parser, onSuccess: onSuccess, onError: onError, onFinally: onFinally)
        } else {
            requestWrapper = self.makeRequest(request: request, converter: converter, responseParser: parser, onSuccess: onSuccess, onError: onError, onFinally: onFinally)
        }
        return requestWrapper
    }
    
    fileprivate class func dataParser<T: ParsableResponse, X>(for responseType: T.Type, responseObjectType: X.Type) -> APIResponseMapper<T> {
    
        let type1Descriptor = String(describing: X.self)
        let type2Descriptor = String(describing: Array<T>.self)
        var parser: APIResponseMapper<T>!
        
        if type1Descriptor == type2Descriptor {
            parser = { (jsonResponse: Any?, responseType: T.Type) in
                let object = jsonResponse != nil ? jsonResponse as? [[String: Any]] : [[String: Any]]()
                guard let jsonObject = object else { throw ServiceError.unexpectedResponseFormat(format: "[[String: Any]]") }
                return try jsonObject.map { try ServiceDataResponse<T>(data: $0).data }
            }
        } else {
            parser = { (jsonResponse: Any?, responseType: T.Type) in
                let object = jsonResponse != nil ? jsonResponse as? [String: Any] : [String: Any]()
                guard let jsonObject = object else { throw ServiceError.unexpectedResponseFormat(format: "[String: Any]") }
                return try ServiceDataResponse<T>(data: jsonObject).data
            }
        }
        return parser
    }
    
    fileprivate class func makeRequest<T: ParsableResponse, E: ParsableResponse, X>(request: ServiceRequest,
                                                                                 converter: ServiceDataConverter? = nil,
                                                                                 responseParser: @escaping APIResponseMapper<T>,
                                                                                 onSuccess: @escaping APISuccessCallback<T, X>,
                                                                                 onError: @escaping APIErrorCallback<E>,
                                                                                 onFinally: @escaping APIFinallyCallback) -> ServiceRequestObject {
        let headers = Service.headers(for: request)
        let encoding = Service.encoding(for: request)
        let requestUrl = Service.url(for: request)
        
        let dataRequest = Alamofire.request(requestUrl,
                                            method: request.endpoint.info.method.alamofireHttpMethod,
                                            parameters: request.body,
                                            encoding: encoding,
                                            headers: headers).validate().responseJSON { response in
                                                Service.process(response: response, converter: converter, responseParser: responseParser, onSuccess: onSuccess, onError: onError, onFinally: onFinally)
        }
        
        return ServiceRequestObject(request: dataRequest)
    }
    
    fileprivate class func makeMultipartRequest<T: ParsableResponse, E: ParsableResponse, X>(request: MultipartRequest,
                                                                                             converter: ServiceDataConverter? = nil,
                                                                                             responseParser: @escaping APIResponseMapper<T>,
                                                                                             onSuccess: @escaping APISuccessCallback<T,X>,
                                                                                             onError: @escaping APIErrorCallback<E>,
                                                                                             onFinally: @escaping APIFinallyCallback) -> ServiceRequestObject {
        let headers = Service.headers(for: request)
        let requestUrl = Service.url(for: request)
        
        let parser: APIResponseMapper<T> = Service.dataParser(for: T.self, responseObjectType: X.self)
        
        let requestWrapper = ServiceRequestObject(request: nil)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            request.body.forEach { multipartFormData.append("\($0.value)".data(using: String.Encoding.utf8)!, withName: $0.key) }
            request.data?.forEach { multipartFormData.append($0.data, withName: $0.name, fileName: $0.fileName, mimeType: $0.mimeType) }
        }, usingThreshold: UInt64.init(), to: requestUrl, method: request.endpoint.info.method.alamofireHttpMethod, headers: headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                let request = upload.validate().responseJSON { response in
                    Service.process(response: response, converter: converter, responseParser: parser, onSuccess: { (resp: Any, type) in onSuccess(resp as! X, type) },
                                    onError: onError,
                                    onFinally: onFinally)
                }
                requestWrapper.set(request: request)
            case .failure(let error): onError(ServiceError.generic(error), E.self)
            }
        }
        return requestWrapper
    }
}

// MARK: Urils
extension Service {

    fileprivate class func process<T: ParsableResponse, E: ParsableResponse, X>(response: DataResponse<Any>,
                                                                             converter: ServiceDataConverter? = nil,
                                                                             responseParser: @escaping APIResponseMapper<T>,
                                                                             onSuccess: @escaping APISuccessCallback<T,X>,
                                                                             onError: @escaping APIErrorCallback<E>,
                                                                             onFinally: @escaping APIFinallyCallback) {
        
        let wrapperOnSuccess: APISuccessCallback<T,X> = { result, type in
            onSuccess(result, type)
            onFinally()
        }
        
        let wrapperOnError: APIErrorCallback<E> = { (errorCode, errorType) in
            onError(errorCode, errorType)
            onFinally()
        }
        
        var jsonResponse = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: JSONSerialization.ReadingOptions(rawValue: 0))
        
        if let responseError = response.error {
            if (responseError as NSError?)?.code == NSURLErrorCancelled { return }
            
            if !Service.isInternetAvailable() { wrapperOnError(.noInternetConnection, E.self) }
            else if let statusCode = response.response?.statusCode, statusCode != 200 {
                let errorDescription = (responseError as? AFError)?.errorDescription
                var parsedError: E? = nil
                if let jsonResponse = jsonResponse as? [String: Any] {
                    parsedError = try? ServiceDataResponse(data: jsonResponse).data
                }
                wrapperOnError(ServiceError.httpResponseNotOK(code: statusCode, message: errorDescription, error: parsedError), E.self)
            }
            else { wrapperOnError(.generic(responseError), E.self) }
            return
        }
        
        do {
            if let converter = converter { jsonResponse = converter.convert(data: jsonResponse) }
            wrapperOnSuccess(try responseParser(jsonResponse, T.self) as! X, T.self)
        } catch (let error) {
            if let serviceError = error as? ServiceError {
                wrapperOnError(serviceError, E.self)
            } else {
                wrapperOnError(ServiceError.generic(error), E.self)
            }
        }
    }
    
    class func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}

// MARK: Helpers
extension Service {
    
    fileprivate class func headers(for request: ServiceRequest) -> HTTPHeaders {
        var headers: HTTPHeaders = [ : ]
        if let serviceHeaders = Service.serviceConfigurator?.requestHTTPHeaders { headers.merge(dict: serviceHeaders) }
        if let requestHeaders = request.HTTPHeaders { headers.merge(dict: requestHeaders) }
        request.excludedHTTPHeaders?.forEach { headers.removeValue(forKey: $0) }
        return headers
    }
    
    fileprivate class func encoding(for request: ServiceRequest) -> ParameterEncoding {
        var encoding: ParameterEncoding = URLEncoding.default
        if let serviceEncoding = Service.serviceConfigurator?.requestEncoding { encoding = serviceEncoding.almofireEncodingType }
        if let requestEncoding = request.encoding { encoding = requestEncoding.almofireEncodingType }
        return encoding
    }
    
    fileprivate class func url(for request: ServiceRequest) -> String {
        let requestUrl = request.url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? request.url
        return requestUrl
    }
}
