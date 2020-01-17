//
//  CartRequest+Remove.swift
//  Cart
//
//  Created by krishna on 16/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import Foundation

extension CartRequest {
    func removeProduct(request: RemoveCartRequestResult, completion: @escaping (RemoveCartResponseResult?, APIError?) -> Void) -> URLSessionTask? {
        serviceRequest = CartRequestService.remove(id: request.id)
        return fetch(headers: nil, completion: { (response: ServiceResponse<RemoveCartResponseResult?>) in
            switch response {
            case .success(let result):
                guard let result = result as? RemoveCartResponseResult else {
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
