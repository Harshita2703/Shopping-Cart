//
//  ServiceRequestError.swift
//  Cart
//
//  Created by krishna on 16/01/2020.
//  Copyright © 2020 harshita. All rights reserved.
//

import Foundation

 protocol ServiceRequestError: Error {
     associatedtype ErrorKind
     var errorType: ErrorKind {get}
     var errorCode: String {get set}
     var errorDescription: String {get set}
 }

