//
//  Reusable.swift
//  Cart
//
//  Created by krishna on 16/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import UIKit

protocol Reusable: class {
    static var reuseIdentifier: String { get }
    static var nib: UINib { get }
}

extension Reusable {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
