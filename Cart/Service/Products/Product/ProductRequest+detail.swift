//
//  ProductRequest+detail.swift
//  Cart
//
//  Created by krishna on 16/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import Foundation
extension ProductsRequest {
    func fetchProductDetails(request: ProductRequestResult, completion: @escaping (ProductResponse?, APIError?) -> Void) -> URLSessionTask? {
        serviceRequest = ProductsRequestService.productDetails(id: request.id)
        return fetch(headers: nil, completion: { (response: ServiceResponse<ProductResponse?>) in
            switch response {
            case .success(let result):
                guard let result = result as? ProductResponse else {
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
