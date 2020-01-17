//
//  ProductsViewController.swift
//  Cart
//
//  Created by krishna on 15/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func showCartItems(_ sender: Any) {
        
    }
    
    @IBAction func showWishlistItems(_ sender: Any) {
        
    }
}

