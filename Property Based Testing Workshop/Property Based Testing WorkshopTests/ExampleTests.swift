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
    
}
