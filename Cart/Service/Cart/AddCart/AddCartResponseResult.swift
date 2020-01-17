//
//  AddCartResponseResult.swift
//  Cart
//
//  Created by krishna on 16/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import Foundation

struct AddCartResponseResult: Codable {
    let cartID, productID: Int

    enum CodingKeys: String, CodingKey {
        case cartID = "cartId"
        case productID = "productId"
    }
}
