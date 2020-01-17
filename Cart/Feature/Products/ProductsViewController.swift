//
//  ProductsViewController.swift
//  Cart
//
//  Created by krishna on 15/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import UIKit

protocol ProductsHandler: class {
    func didRemoveFromCart(product: ProductModel)
    func didRemoveFromWishList(product: ProductModel)
    func didMoveToCart(product: ProductModel)
}

protocol ButtonHandler: class {
    func didSelectToAddCart(product: ProductModel, indexPath: IndexPath)
    func didMoveToWishList(product: ProductModel, indexPath: IndexPath)
}

class ProductsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var productsFetcher: ProductsRequesting?
    var cartRequester: CartRequesting?
    var products: [ProductModel]?
    var isFirstTime: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        productsFetcher = ProductsRequest()
        cartRequester = CartRequest()
        self.navigationController?.navigationBar.isHidden = true
        collectionView.register(ProductCollectionViewCell.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstTime {
            fetchAllProducts()
            isFirstTime = false
        } else {
            collectionView.reloadData()
        }
    }

    @IBAction func showCartItems(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc: CartViewDisplaying = storyboard.instantiateViewController(identifier: StoryBoardIdentifier.cart.rawValue) as? CartViewController else { return }
        vc.products = self.products?.filter({$0.isInCart == true})
        vc.handler = self
        self.navigationController?.pushViewController(vc as! UIViewController, animated: true)
    }
    
    @IBAction func showWishlistItems(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc: WishListDisplaying = storyboard.instantiateViewController(identifier: StoryBoardIdentifier.wishList.rawValue) as? WishListViewController else { return }
        vc.products = self.products?.filter({$0.isInWishList == true})
        vc.handler = self
        self.navigationController?.pushViewController(vc as! UIViewController, animated: true)
    }
    
    func fetchAllProducts() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            _ = self?.productsFetcher?.fetchProducts(completion: {  (response, error) in
                 if let _response = response {
                     self?.products = _response.map({ProductModel(response: $0)})
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                 } else if let _error = error {
                     print("\(_error.localizedDescription)")
                 }
                 
             })
        }
    }
    
    func addToCart(product: ProductModel) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let request = AddCartRequestResult(productId: product.productID)
            _ = self?.cartRequester?.addProduct(request: request, completion: { (response, error) in
                if nil == error {
                    DispatchQueue.main.async {
                        self?.showAlertForProductAddedToCart()
                    }
                }
            })
        }
    }
    
    func showAlertForOutOfStockProduct() {
        let okayAction = AlertActionHandler(title: "OK", type: .default)
        showAlert(with: "", message: "Currently Product is Unavailable", actions: [okayAction])
    }

    func showAlertForProductAddedToCart() {
        let okayAction = AlertActionHandler(title: "OK", type: .default)
        showAlert(with: "", message: "Product Successfully added to Cart", actions: [okayAction])
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

extension ProductsViewController: ButtonHandler {
    func didSelectToAddCart(product: ProductModel, indexPath: IndexPath) {
        if product.isInStock == true {
            product.isInCart = true
            addToCart(product: product)
        } else {
            self.showAlertForOutOfStockProduct()
        }
    }
    
    func didMoveToWishList(product: ProductModel, indexPath: IndexPath) {
        product.isInWishList = !product.isInWishList
        collectionView.reloadItems(at: [indexPath])
    }
}

extension ProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ProductCollectionViewCell.self)
        guard let model = products?[indexPath.row] else {
             return UICollectionViewCell()
        }
        cell.handler = self
        cell.configureCell(with: model, at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 130)
    }
}

extension ProductsViewController: ProductsHandler {
    func didRemoveFromCart(product: ProductModel) {
        guard let product = self.products?.filter({$0.productID == product.productID}).last else { return }
        product.isInCart = false
    }
    
    func didRemoveFromWishList(product: ProductModel) {
        guard let product = self.products?.filter({$0.productID == product.productID}).last else { return }
        product.isInWishList = false
    }
    
    func didMoveToCart(product: ProductModel) {
        guard let product = self.products?.filter({$0.productID == product.productID}).last else { return }
        product.isInWishList = false
        product.isInCart = true
    }
}
