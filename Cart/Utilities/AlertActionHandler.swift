//
//  AlertActionHandler.swift
//  Cart
//
//  Created by krishna on 17/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import Foundation
import UIKit

protocol AlertActionHandling {
    var title: String {get set}
    var type: UIAlertAction.Style {get set}
    var completion: (() -> Void)? {get set}
    var isEnabled: Bool {get set}
}

struct AlertActionHandler: AlertActionHandling {
    var title: String = "Cancel"
    var type: UIAlertAction.Style = .default
    var isEnabled: Bool = true
    var completion: (() -> Void)?
    
    init(title: String, type:  UIAlertAction.Style, completion: (() -> Void)? = nil) {
        self.title = title
        self.type = type
        self.completion = completion
    }
}
