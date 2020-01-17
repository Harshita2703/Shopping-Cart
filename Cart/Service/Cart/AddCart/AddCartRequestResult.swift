//
//  AddCartRequestResult.swift
//  Cart
//
//  Created by krishna on 16/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import Foundation
struct  AddCartRequestResult {
    
    let productId: Int

    func toJSON() -> [String: Any] {
        return ["productId": productId] as [String: Any]
    }
    
}

