//
//  CartCollectionViewCell.swift
//  Cart
//
//  Created by krishna on 16/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import UIKit

class CartCollectionViewCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!

    var product: ProductModel?
    weak var cartHandler: CartHandler?
    weak var wishListHandler: WishListHandler?
    var type: CellType?

    override func awakeFromNib() {
        super.awakeFromNib()
        addToCartButton.layer.borderWidth = 2.0
        addToCartButton.layer.borderColor = UIColor.black.cgColor
    }
    
    func configureCell(type: CellType) {
        self.type = type
        switch type {
        case .wishList(let wishListHandler, let model):
            self.wishListHandler = wishListHandler
            self.product = model
            addToCartButton.isHidden = false
        case .cart(let cartHandler, let model):
            self.cartHandler = cartHandler
            self.product = model
            addToCartButton.isHidden = true
            
        }
        configureCell( product: self.product)
    }
    
    func configureCell(product: ProductModel?) {
        guard  let _product = self.product else {
            return
        }
        categoryLabel.text = _product.category
        nameLabel.text = _product.name
        priceLabel.text = "\(_product.price)"
    }
    
    @IBAction func removeFromCart(_ sender: Any) {
        guard let _product = self.product, let cellType = self.type else {
            return
        }
        switch cellType {
        case .wishList:
            wishListHandler?.didRemoveProductFromWishList(productModel: _product)
        case .cart:
            cartHandler?.didRemoveProductFromCart(productModel: _product)
            
        }
    }
    
    @IBAction func addToCart(_ sender: Any) {
        if let _product = self.product {
            wishListHandler?.addProductToCart(productModel: _product)
        }
    }
}

