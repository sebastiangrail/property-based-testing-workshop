import XCTest
import SwiftCheck
@testable import Property_Based_Testing_Workshop

extension Result: Arbitrary where Value: Arbitrary, Error: Arbitrary {
    public static var arbitrary: Gen<Result<Value, Error>> {
        return Gen.compose { composer -> Result<Value, Error> in
            if composer.generate() {
                let value: Value = composer.generate()
                return Result.success(value)
            } else {
                let error: Error = composer.generate()
                return Result.failure(error)
            }
        }
    }
    
    public static func shrink(_ result: Result) -> [Result] {
        switch result {
        case .success(let value):
            return Value.shrink(value).map { Result.success($0)}
        case .failure(let error):
            return Error.shrink(error).map { Result.failure($0)}
        }
    }
}


class ResultTests: XCTestCase {
    
    func testFunctorLaws() {
        property("mapping identity is identity") <- forAll { (x: Result<Int, String>) in
            x.map { $0 } == x
        }
        
        property("map(f•g) = map(f)•map(g)") <- forAll { (x: Result<Int, String>, arrowF: ArrowOf<String, Int>, arrowG: ArrowOf<Int, String>) in
            let f = arrowF.getArrow
            let g = arrowG.getArrow
            return x.map { f(g($0)) } == x.map(g).map(f)
        }
    }
    
}
