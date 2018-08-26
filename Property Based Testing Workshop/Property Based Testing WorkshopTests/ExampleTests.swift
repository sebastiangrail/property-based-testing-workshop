import XCTest
import SwiftCheck
@testable import Property_Based_Testing_Workshop

class ExampleTests: XCTestCase {

    func testMax() {
        property("max returns one of its inputs") <- forAll { (a: Int, b: Int) in
            max(a,b) == a || max(a,b) == b
        }
        
        property("the output is >= to both inputs") <- forAll { (a: Int, b: Int) in
            max(a,b) >= a && max(a,b) >= b
        }
    }
    
    func testMin() {
        property("min returns one of its inputs") <- forAll { (a: Int, b: Int) in
            min(a,b) == a || min(a,b) == b
        }
        
        property("the output is <= to both inputs") <- forAll { (a: Int, b: Int) in
            min(a, b) <= a && min(a, b) <= b
        }
    }
    
    func testMin2() {
        // No need to test that min2 returns one of its input as it's encoded in the type system.
        
        property("the output is <= to both inputs") <- forAll { (a: Int, b: Int) in
            min2(a, b) <= a && min2(a, b) <= b
        }
    }
    
    func testReversed() {
        property("reverse twice is identity") <- forAll { (xs: [Int]) in
            xs.reversed().reversed() == xs
        }
        
        property("reversing then appending is equal to prepending and then reversing") <- forAll { (xs: [Int], x: Int) in
            let a = Array(xs.reversed()) + [x]
            var b = [x]
            b.append(contentsOf: xs)
            return a == b.reversed()
        }
    }
}
