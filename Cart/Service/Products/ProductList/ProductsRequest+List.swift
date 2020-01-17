//
//  ProductsRequest+List.swift
//  Cart
//
//  Created by krishna on 16/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import Foundation

extension ProductsRequest {
    func fetchProducts(completion: @escaping ([ProductResponse]?, APIError?) -> Void) -> URLSessionTask? {
        serviceRequest = ProductsRequestService.products
        return fetch(headers: nil, completion: { (response: ServiceResponse<[ProductResponse]?>) in
            switch response {
            case .success(let result):
                guard let result = result as? [ProductResponse] else {
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
