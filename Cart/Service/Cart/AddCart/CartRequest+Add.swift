//
//  CartRequest+Add.swift
//  Cart
//
//  Created by krishna on 16/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import Foundation
extension CartRequest {
    func addProduct(request: AddCartRequestResult, completion: @escaping (AddCartResponseResult?, APIError?) -> Void) -> URLSessionTask? {
        serviceRequest = CartRequestService.add(params: request.toJSON())
        return fetch(headers: nil, completion: { (response: ServiceResponse<AddCartResponseResult?>) in
            switch response {
            case .success(let result):
                guard let result = result as? AddCartResponseResult else {
                    completion(nil, APIError.jsonParsingFailure)
                    return
                }
                completion(result, nil)
            case .failure:
                completion(nil, APIError.jsonParsingFailure)
            }
        })
    }
}
