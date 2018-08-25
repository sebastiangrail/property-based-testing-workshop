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
    
    /// Returns the prefix of the list of up to `length` items
    func prefix(_ length: Int) -> List<T> {
        fatalError()
    }
    
    /// Returns the suffix of the list of up to `length` items
    func suffix(_ length: Int) -> List<T> {
        fatalError()
    }
    
    /// Appends a list to the end of this list
    func append(_ other: List<T>) -> List<T> {
        fatalError()
    }
    
    /// Returns the list reversed
    var reversed: List<T> {
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
}

extension List where T: Comparable {
    /// Merges two sorted list
    func merge(with other: List<T>) -> List<T> {
        fatalError()
    }
}

extension List: Equatable where T: Equatable {
    public static func ==(lhs: List, rhs: List) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case (.cons(let leftHead, let leftTail), .cons(let rightHead, let rightTail)):
            return leftHead == rightHead && leftTail == rightTail
        case (.empty, _), (_, .empty):
            return false
        }
    }
    
    func contains(_ element: T) -> Bool {
        switch self {
        case .empty:
            return false
        case .cons(let head, let tail):
            return head == element || tail.contains(element)
        }
    }
}

extension List {
    var isEmpty: Bool {
        switch self {
        case .empty: return true
        case .cons: return false
        }
    }
}
