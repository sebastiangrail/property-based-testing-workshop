import XCTest
import SwiftCheck
@testable import Property_Based_Testing_Workshop

extension Point: Arbitrary {
    /// Creating a generator using `compose`
    public static var arbitrary: Gen<Point> {
        return Gen.compose { composer in
            return Point(
                x: composer.generate(),
                y: composer.generate())
        }
    }
    
    /// Creating a generator using `zipWith`
    public static var arbitrary2: Gen<Point> {
        return Gen.zipWith(Int.arbitrary, Int.arbitrary, transform: Point.init)
    }
    
    /// Shrinking using Swift's `zip` function. Notice how this is very similar to the shrinker above.
    /// This creates min(n, m) points, where n and m are the sizes of the shrunk components.
    public static func shrink(_ point: Point) -> [Point] {
        return zip(Int.shrink(point.x), Int.shrink(point.y)).map(Point.init)
    }
    
    /// Shrinking with `flatMap`.
    /// This creates (n+1)*(m+1) points, where n and m are the sizes of the shrunk components.
    public static func shrink2(_ point: Point) -> [Point] {
        return Array((Int.shrink(point.x) + [point.x]).flatMap { x in
            (Int.shrink(point.y) + [point.y]).map { y in
                Point(x: x, y: y)
            }
        }.dropLast())
    }
}

class PointTests: XCTestCase {

    func testShiftBy() {
        property("shift and shift back is identity") <- forAll { (point: Point, dx: Int, dy: Int) in
            var copy = point
            copy.shiftBy(dx: dx, dy: dy)
            copy.shiftBy(dx: -dx, dy: -dy)
            return copy == point
        }
        
        property("point is unchanged iff deltas are 0") <- forAll { (point: Point, dx: Int, dy: Int) in
            var copy = point
            copy.shiftBy(dx: dx, dy: dy)
            if dx == 0 && dy == 0 {
                return point == copy
            } else {
                return point != copy
            }
        }
        
        property("shifting twice is equal to shifting by twice the amount") <- forAll { (point: Point, dx: Int, dy: Int) in
            var copy = point
            copy.shiftBy(dx: dx, dy: dy)
            copy.shiftBy(dx: dx, dy: dy)
            
            var copy2 = point
            copy2.shiftBy(dx: 2*dx, dy: 2*dy)
            
            return copy == copy2
        }
        
        property("shifting the zero point by (dx, dy) is equal to the point at (dx, dy)") <- forAll { (dx: Int, dy: Int) in
            var point = Point(x: 0, y: 0)
            point.shiftBy(dx: dx, dy: dy)
            return point == Point(x: dx, y: dy)
        }
    }
    
}
