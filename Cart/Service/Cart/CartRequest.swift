//
//  CartRequest.swift
//  Cart
//
//  Created by krishna on 16/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import Foundation
protocol CartRequesting {
    func addProduct(request: AddCartRequestResult, completion: @escaping(AddCartResponseResult?, APIError?) -> Void) -> URLSessionTask?
    func removeProduct(request: RemoveCartRequestResult, completion: @escaping(RemoveCartResponseResult?, APIError?) -> Void) -> URLSessionTask?
}

class CartRequest: BaseService, CartRequesting {
    override var description: String {
        return "/cart"
    }
}


enum  CartRequestService: ServiceRequestable {
    case add(params: [String: Any])
    case remove(id: Int)
    
    var httpMethod: APIMethod {
        switch self {
        case .add :
            return .post
        case .remove:
            return .delete
        }
    }
    
    var method: String? {
        switch self {
        case .remove(let id):
            return "/\(id)"
        default:
            return nil
            
        }
    }
    
    var params: [String: Any]? {
        switch self {
        case .add(let params):
            return params
        default:
            return nil
        }
    }

}
