//
//  Helpers.swift
//  Property Based Testing WorkshopTests
//
//  Created by Sebastian Grail on 24/8/18.
//  Copyright © 2018 Sebastian Grail. All rights reserved.
//

import Foundation
import UIKit
import SwiftCheck

func unaryFunctionGen<A, R>() -> Gen<(A) -> R> where A: Hashable, A: CoArbitrary, R: Arbitrary {
    return ArrowOf<A, R>.arbitrary.map { $0.getArrow }
}

func binaryFunctionGen<A, B, R>() -> Gen<(A, B) -> R> where A: Hashable, B: Hashable, A: CoArbitrary, B: CoArbitrary, R: Arbitrary {
    return ArrowOf<Pair<A, B>, R>.arbitrary.map { arrow in
        return { a, b in
            arrow.getArrow(Pair(first: a, second: b))
        }
    }
}

extension UIImage {
    static func image(withSize size: CGSize, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(color.cgColor)
        context.addRect(CGRect(origin: .zero, size: size))
        context.drawPath(using: .fill)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension Sequence {
    func all(predicate: (Element) -> Bool) -> Bool {
        for element in self {
            if !predicate(element) {
                return false
            }
        }
        return true
    }
}

// Mark: Implementation details

private struct Pair<A: Hashable, B: Hashable>: Hashable {
    var first: A
    var second: B
}

extension Pair: Arbitrary where A: Arbitrary, B: Arbitrary {
    static var arbitrary: Gen<Pair<A, B>> {
        return Gen.zipWith(A.arbitrary, B.arbitrary) { Pair(first: $0, second: $1) }
    }
}

extension Pair: CoArbitrary where A: CoArbitrary, B: CoArbitrary {
    static func coarbitrary<C>(_ x: Pair<A, B>) -> ((Gen<C>) -> Gen<C>) {
        let a: (Gen<C>) -> Gen<C> = A.coarbitrary(x.first)
        let b: (Gen<C>) -> Gen<C> = B.coarbitrary(x.second)
        return { gen in
            b(a(gen))
        }
    }
}


