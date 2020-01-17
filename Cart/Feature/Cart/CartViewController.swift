//
//  CartViewController.swift
//  Cart
//
//  Created by krishna on 15/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import UIKit

protocol CartViewDisplaying: class {
    var products: [ProductModel]? { get set}
    var handler: ProductsHandler? { get set }
}

protocol CartHandler: class {
    func didRemoveProductFromCart(productModel: ProductModel)
}

class CartViewController: UIViewController, CartViewDisplaying {

    @IBOutlet weak var totalPriceView: UIView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var emptyMsgLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var cartRequester: CartRequesting?
    var products: [ProductModel]?
    weak var handler: ProductsHandler?
    var productToRemove: ProductModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(CartCollectionViewCell.self)
        cartRequester = CartRequest()
        totalPriceView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
        updateTotalPrice()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateTotalPrice() {
        var price = 0.0
        products?.forEach({ (product) in
            price += product.price
        })
        if price == 0 {
            totalPriceView.isHidden = true
        } else {
            totalPriceView.isHidden = false
            totalPrice.text = "\(price)"
        }
    }
    
    func removeProductFromCart(product: ProductModel?) {
        guard let _product = product else { return }
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            let request = RemoveCartRequestResult(id: _product.productID)
            _ = self?.cartRequester?.removeProduct(request: request, completion: { (response, error) in
                DispatchQueue.main.async {
                    if error == nil {
                        print("Removed From cart")
                    }
                    self?.products?.removeAll(where: { (productModel) -> Bool in
                        return productModel.productID == _product.productID
                    })
                    self?.collectionView.reloadData()
                    self?.updateTotalPrice()
                    self?.handler?.didRemoveFromCart(product: _product)
                }
            })
        }
    }
    
    func showConfirmationAlertToRemoveItem() {
        let okayAction = AlertActionHandler(title: "Ok", type: .default) { [weak self] in
            self?.removeProductFromCart(product: self?.productToRemove)
        }
        let cancelAction = AlertActionHandler(title: "Cancel", type: .cancel)
        showAlert(with: "CART", message: "Are you sure? Do you want to remove the Product", actions: [okayAction, cancelAction])
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

extension CartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        guard let model = products?[indexPath.row] else {
            return UICollectionViewCell()
        }
        cell.configureCell(type: CellType.cart(self, model))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
    }
}

extension CartViewController: CartHandler {
     func didRemoveProductFromCart(productModel: ProductModel) {
        self.productToRemove = productModel
        showConfirmationAlertToRemoveItem()
    }
}

