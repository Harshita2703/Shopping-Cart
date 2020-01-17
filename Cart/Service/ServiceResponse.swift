//
//  ServiceResponse.swift
//  Cart
//
//  Created by krishna on 16/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import Foundation

enum ServiceResponse<T> {
    case success(T?)
    case failure(Error)
}
