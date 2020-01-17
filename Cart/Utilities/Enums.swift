//
//  Enums.swift
//  Cart
//
//  Created by krishna on 16/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import Foundation

enum StoryBoardIdentifier: String {
    case products = "ProductsViewController"
    case cart = "CartViewController"
    case wishList = "WishListViewController"
}

enum CellType {
    case wishList(WishListHandler, ProductModel)
    case cart(CartHandler, ProductModel)
}
