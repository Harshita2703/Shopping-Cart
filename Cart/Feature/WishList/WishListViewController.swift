//
//  WishListViewController.swift
//  Cart
//
//  Created by krishna on 15/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import UIKit

protocol WishListDisplaying: class {
    var products: [ProductModel]? { get set }
    var handler: ProductsHandler? { get set}
}

protocol WishListHandler: class {
    func addProductToCart(productModel: ProductModel)
    func didRemoveProductFromWishList(productModel: ProductModel)
}

class WishListViewController: UIViewController, WishListDisplaying {

    @IBOutlet weak var collectionView: UICollectionView!
    var products: [ProductModel]?
    weak var handler: ProductsHandler?
    var cartRequester: CartRequesting?
    @IBOutlet weak var emptyMsgLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(CartCollectionViewCell.self)
        cartRequester = CartRequest()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addToCart(product: ProductModel) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let request = AddCartRequestResult(productId: product.productID)
            _ = self?.cartRequester?.addProduct(request: request, completion: { (response, error) in
                if nil == error {
                    DispatchQueue.main.async {
                        print("Added Produt to cart")
                        self?.handler?.didMoveToCart(product: product)
                        self?.showAlertForProductAddedToCart()
                    }
                }
            })
        }
    }
    
    func showAlertForProductAddedToCart() {
        let okayAction = AlertActionHandler(title: "OK", type: .default)
        showAlert(with: "", message: "Product Successfully added to Cart", actions: [okayAction])
    }
    
    func showAlertForOutOfStockProduct() {
        let okayAction = AlertActionHandler(title: "OK", type: .default)
        showAlert(with: "", message: "Currently Product is Unavailable", actions: [okayAction])
    }

    func showAlert(with title: String?, message: String?, actions: [AlertActionHandling]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            let alertAction = UIAlertAction(title: action.title, style: action.type) { (_) in
                action.completion?()
            }
            alertAction.isEnabled = action.isEnabled
            alert.addAction(alertAction)
        }
        if let popOver = alert.popoverPresentationController, let sourceView = self.view {
            popOver.sourceView = self.view
            popOver.sourceRect = CGRect(x: sourceView.bounds.midX, y: sourceView.bounds.midY, width: 0, height: 0)
            popOver.permittedArrowDirections = []
        }
        self.present(alert, animated: true, completion: nil)
    }

}

extension WishListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = self.products?.count else {
            emptyMsgLabel.isHidden = false
            return 0
        }
        emptyMsgLabel.isHidden = (count != 0)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CartCollectionViewCell.self)
        guard let model = self.products?[indexPath.row] else { return UICollectionViewCell() }
        cell.configureCell(type: CellType.wishList(self, model))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 130.0)
    }
}

extension WishListViewController: WishListHandler {
    func didRemoveProductFromWishList(productModel: ProductModel) {
        self.products?.removeAll(where: { (product) -> Bool in
            return product.productID == productModel.productID
        })
        collectionView.reloadData()
        self.handler?.didRemoveFromWishList(product: productModel)
    }
    
    func addProductToCart(productModel: ProductModel) {
        if productModel.isInStock == true {
            self.products?.removeAll(where: { (product) -> Bool in
                return product.productID == productModel.productID
            })
            collectionView.reloadData()
            addToCart(product: productModel)
        } else {
            showAlertForOutOfStockProduct()
        }
    }
}
