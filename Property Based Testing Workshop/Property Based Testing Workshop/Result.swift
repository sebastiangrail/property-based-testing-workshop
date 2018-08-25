//
//  Result.swift
//  Property Based Testing Workshop
//
//  Created by Sebastian Grail on 26/8/18.
//  Copyright © 2018 Sebastian Grail. All rights reserved.
//

import Foundation

public enum Result<Value, Error: Swift.Error> {
    case success(Value)
    case failure(Error)
    
    func map<T>(_ transform: (Value) -> T) -> Result<T, Error> {
        fatalError()
    }
}
