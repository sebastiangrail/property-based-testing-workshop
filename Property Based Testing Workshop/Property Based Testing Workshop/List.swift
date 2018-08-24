//
//  List.swift
//  Property Based Testing Workshop
//
//  Created by Sebastian Grail on 24/8/18.
//  Copyright © 2018 Sebastian Grail. All rights reserved.
//

import Foundation

public indirect enum List<T> {
    case empty
    case cons(T, List<T>)
    
    /// Returns the length of the list
    var length: Int {
        fatalError()
    }
    
    /// Returns the first element of the list
    var head: T? {
        fatalError()
    }
    
    /// Returns all elements following the first element of the list
    var tail: List<T>? {
        fatalError()
    }
    
    /// Applies `transform` to all elements of the list
    func map<U>(transform: (T) -> U) -> List<U> {
        fatalError()
    }
    
    /// Returns the list of elements that satisfy the predicate
    func filter(predicate: (T) -> Bool) -> List<T> {
        fatalError()
    }
    
    /// Returns the list reversed
    var reversed: List<T> {
        fatalError()
    }
}

extension List where T: Comparable {
    /// Merges two sorted list
    func merge(with other: List<T>) -> List<T> {
        fatalError()
    }
}
