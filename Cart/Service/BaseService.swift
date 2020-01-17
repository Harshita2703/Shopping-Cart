//
//  BaseService.swift
//  Cart
//
//  Created by krishna on 16/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import Foundation
class BaseService: NSObject {
    var serviceRequest: ServiceRequestable?
    
    @discardableResult
    func fetch<T: Decodable>(headers: [String: String]?, completion: @escaping (ServiceResponse<T?>) -> Void) -> URLSessionTask? {
        
        guard let endPointString = endPoint() else {return nil}
        let url = URL(string: endPointString)
        guard  let path = url else {
            let result = ServiceResponse<T?>.failure(APIError.invalidURL)
            completion(result)
            return nil
        }
        let params = serviceRequest?.params
        
        guard let httpmethod = self.serviceRequest?.httpMethod else {
            let result = ServiceResponse<T?>.failure(APIError.invalidHTTPMethod)
            completion(result)
            return nil
        }
        
        
        return ServiceRequest.request(with: path, params: params, method: httpmethod, headers: self.allHeaders(headers: headers), completion: { (data, error) in
            self.handleResponse(for: data, error: error, completion: completion)
        })
        
    }
    
    
    private func handleResponse<T: Decodable>(for data: Data?, error: Error?, completion: @escaping (ServiceResponse<T?>) -> Void) {
        guard let data = data else {
            if let responseError = error as NSError? {
                let result = ServiceResponse<T?>.failure(responseError)
                completion(result)
                return
            }
            return
        }
        self.serviceResponseHandler(response: data, completion: completion)
    }
    
    func handleServiceError<T: ServiceRequestError>(serviceError: Error, error: T) -> T {
        
        let serviceError = serviceError as NSError
        var error = error
        let userInfo = serviceError.userInfo
        let key: String = userInfo[NSLocalizedFailureReasonErrorKey] as? String ?? "unknown"
        let errorMessage: String = userInfo[NSLocalizedDescriptionKey] as? String ?? "Something went wrong"
        error.errorCode = key
        error.errorDescription = errorMessage
        return error
        
    }
    
    
    
    private func serviceResponseHandler<T: Decodable>(response: Data, completion: @escaping (ServiceResponse<T?>) -> Void) {
        do {
            let reponseObject = try JSONSerialization.jsonObject(with: response, options: [])
//            guard  else {
//                let result = ServiceResponse<T?>.failure(APIError.jsonParsingFailure)
//                completion(result)
//                return
//            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: reponseObject as Any, options: [])
                let decoded = try JSONDecoder().decode(T.self, from: jsonData)
                let result = ServiceResponse<T?>.success(decoded)
                completion(result)
            } catch let exception {
                print(exception)
                let result = ServiceResponse<T?>.failure(APIError.jsonParsingFailure)
                completion(result)
            }
            
        } catch let exception {
            print(exception)
            let result = ServiceResponse<T?>.failure(APIError.jsonParsingFailure)
            completion(result)
        }
    }
    
    func allHeaders(headers: [String: String]? ) -> [String: String]? {
        if let _headers = headers {
            return _headers
        }
        return [ServiceHeaders.contentType.rawValue: "application/json"]
    }
    func endPoint() -> String? {
        let endpoint: String = "http://private-anon-f5ac41ccdb-ddshop.apiary-mock.com"
        guard let request = serviceRequest?.method else {
            return "\(endpoint)/\(description)"
        }
        return "\(endpoint)\(description)\(request)"
    }
    
}
