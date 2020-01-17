//
//  ServiceRequstable.swift
//  Cart
//
//  Created by krishna on 16/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import Foundation

protocol ServiceRequestable {
    var httpMethod: APIMethod {get}
    var method: String? {get}
    var params: [String: Any]? {get}
}
