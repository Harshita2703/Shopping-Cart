//
//  APIError.swift
//  Cart
//
//  Created by krishna on 16/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import Foundation
enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    case invalidURL
    case invalidHTTPMethod
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidURL: return "Invalid Request URL"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        case .invalidHTTPMethod: return "HTTP method not defined"
        }
    }
}
