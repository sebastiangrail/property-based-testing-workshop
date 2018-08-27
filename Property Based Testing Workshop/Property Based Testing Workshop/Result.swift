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
        switch self {
        case .success(let value):
            return .success(transform(value))
        case .failure(let error):
            return .failure(error)
        }
    }
}

extension Result: Equatable where Value: Equatable, Error: Equatable {
    public static func ==(lhs: Result, rhs: Result) -> Bool {
        switch (lhs, rhs) {
        case (.success(let left), .success(let right)):
            return left == right
        case (.failure(let left), .failure(let right)):
            return left == right
        case (.success, _), (.failure, _):
            return false
        }
    }
}
