//
//  ProductModel.swift
//  Cart
//
//  Created by krishna on 16/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import Foundation

class ProductModel {
    let productID: Int
    let name, category: String
    let price: Double
    let stock: Int
    var isInStock: Bool = false
    var isInWishList: Bool = false
    var isInCart: Bool = false
    
    init(response: ProductResponse) {
        self.productID = response.productID
        self.price = response.price
        self.name = response.name
        self.category = response.category
        self.stock = response.stock
        if response.stock > 0 {
            self.isInStock = true
        }
    }
}
