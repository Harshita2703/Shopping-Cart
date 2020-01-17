//
//  ServiceRequest.swift
//  Cart
//
//  Created by krishna on 16/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import Foundation

struct ServiceRequest {
    
    static func request(with request: URL,
                        params: [String: Any]?,
                        method: APIMethod,
                        headers: [String: String]?,
                        completion: @escaping (Data?, Error?) -> Void) -> URLSessionTask? {
        var httpBody: Data?
        if let bodyParams = params {
            httpBody = ServiceRequest.getHttpBody(params: bodyParams)
        }
        
        guard let request = ServiceRequest.prepareRequest(withURL: request, httpBody: httpBody, httpMethod: method, headers: headers) else {
            completion(nil, nil)
            return nil
        }
        
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration)
        let task = session.dataTask(with: request) { (data, response, error) in
            completion(data, error)
        }
        task.resume()
        return task
    }
    
    static private func prepareRequest(withURL url: URL?, httpBody: Data?, httpMethod: APIMethod, headers: [String: String]?) -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        if let requestHeaders = headers {
            for (header, value) in requestHeaders {
                request.setValue(value, forHTTPHeaderField: header)
            }
        }
        request.httpBody = httpBody
        return request
    }
    
    static private func getHttpBody(params: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: params, options: [.prettyPrinted, .sortedKeys])
    }
    
    static func createError(response: Data, statusCode: Int) -> Error? {
        guard let reponseObject = try? JSONSerialization.jsonObject(with: response, options: []) as? [String: Any] else {
            return nil
        }
        let message = reponseObject["message"] ?? "Something went Wrong"
        let key = reponseObject["key"] ?? "unknown"
        let userInfo = [NSLocalizedDescriptionKey: message,
                        NSLocalizedFailureReasonErrorKey: key]
        return NSError(domain: "Service Error", code: statusCode, userInfo: userInfo)
    }
}
