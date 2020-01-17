//
//  ProductsRequest.swift
//  Cart
//
//  Created by krishna on 16/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import Foundation
protocol ProductsRequesting {
    func fetchProducts(completion: @escaping([ProductResponse]?, APIError?) -> Void) -> URLSessionTask?
    func fetchProductDetails(request: ProductRequestResult, completion: @escaping(ProductResponse?, APIError?) -> Void) -> URLSessionTask?
}

class ProductsRequest: BaseService, ProductsRequesting {
    override var description: String {
        return "products"
    }
}


enum  ProductsRequestService: ServiceRequestable {
    case products
    case productDetails(id: Int)
    
    var httpMethod: APIMethod {
        switch self {
        case .products, .productDetails:
            return .get
        }
    }
    
    var method: String? {
        switch self {
        case .productDetails(let id):
            return "/\(id)"
        default:
            return nil
            
        }
    }
    
    var params: [String: Any]? {
        return nil
    }

}
