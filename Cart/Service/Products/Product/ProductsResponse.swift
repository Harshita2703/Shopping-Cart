//
//  ProductsResponse.swift
//  Cart
//
//  Created by krishna on 16/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import Foundation

struct ProductResponse: Codable {
    let productID: Int
    let name, category: String
    let price: Double
    let stock: Int

    enum CodingKeys: String, CodingKey {
        case productID = "productId"
        case name, category, price, stock
    }
}
