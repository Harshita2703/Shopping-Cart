//
//  ProductCollectionViewCell.swift
//  Cart
//
//  Created by krishna on 16/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var wishListButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    weak var handler: ButtonHandler?
    var product: ProductModel?
    var indexPath: IndexPath?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(with model: ProductModel, at indexPath: IndexPath) {
        self.product = model
        self.indexPath = indexPath
        categoryLabel.text = model.category
        priceLabel.text = "\(model.price)"
        nameLabel.text = model.name
        stockLabel.text = model.isInStock ? "Available": "Out Of Stock"
        wishListButton.setImage(UIImage(named: model.isInWishList ? "wishlist_active" : "wishlist"), for: .normal)
    }

    @IBAction func addToWishList(_ sender: Any) {
        if let _product = product, let _indexPath = indexPath {
            handler?.didMoveToWishList(product: _product, indexPath: _indexPath)
        }
    }
    
    @IBAction func addToCart(_ sender: Any) {
        if let _product = product, let _indexPath = indexPath {
            handler?.didSelectToAddCart(product: _product, indexPath: _indexPath)
        }
    }
}
