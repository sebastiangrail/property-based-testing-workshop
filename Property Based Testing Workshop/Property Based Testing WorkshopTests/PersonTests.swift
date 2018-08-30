import XCTest
import SwiftCheck
@testable import Property_Based_Testing_Workshop

/// A generator for images using `compose`
/// `UIImage` can't conform to `Arbitrary` because it is non-final and the protocol has `Self`-requirements
func imageGen(colorGen: Gen<UIColor>, sizeGen: Gen<CGSize>) -> Gen<UIImage> {
    return Gen<UIImage>.compose { composer in
        return UIImage.image(
            withSize: composer.generate(using: sizeGen),
            color: composer.generate(using: colorGen))
    }
}

/// A generator for images using `zipWith`
func imageGen2(colorGen: Gen<UIColor>, sizeGen: Gen<CGSize>) -> Gen<UIImage> {
    return Gen.zipWith(sizeGen, colorGen, transform: UIImage.image(withSize:color:))
}

/// A generator for `CGSize` restricted to strictly positive whole number width and height
let sizeGen = Gen<CGSize>.compose { composer in
    let intGen =  Int.arbitrary.map { abs($0) + 1 }
    return CGSize(
        width: composer.generate(using: intGen),
        height: composer.generate(using: intGen))
}

/// A generator for `UIColor`
let colorGen = Gen<UIColor>.compose { composer in
    let componentGen = Gen<Double>.choose((0, 1)).map { CGFloat($0) }
    return UIColor(
        red: composer.generate(using: componentGen),
        green: composer.generate(using: componentGen),
        blue: composer.generate(using: componentGen),
        alpha: composer.generate(using: componentGen))
}

extension Person: Arbitrary {
    /// A generator using `zipWith` with custom generators
    public static var arbitrary: Gen<Person> {
        return Gen.zipWith(
            /// Another way to create `String` generator
            /// First choose a character from "a" to "z", `proliferate to create an Array of characters, then map to turn it into a `String`
            Gen<Character>.choose(("a", "z")).proliferate.map { String($0) },
            /// To generate larger description `String`s we can scale the generator's size quadratically.
            String.arbitrary.scale { $0 * $0 },
            imageGen(colorGen: colorGen, sizeGen: sizeGen),
            transform: Person.init)
    }
    
    /// A generator using `compose` with default `String` generators
    /// The data generated might not be big enough to surface all all bugs in `PersonCard`
    public static var arbitrary2: Gen<Person> {
        return Gen.compose { composer in
            return Person(
                name: composer.generate(),
                description: composer.generate(),
                avatar: composer.generate(using: imageGen(colorGen: colorGen, sizeGen: sizeGen)))
        }
    }
    
    /// A simplified shrinker for `Person`
    /// Since UI tests take a long time this is a practical approach to finding some bugs.
    /// An improved approach could remove every nth element instead of only taking the first 20.
    public static func shrinkSimple(_ person: Person) -> [Person] {
        let names = String.shrink(person.name)
        let descriptions = String.shrink(person.description)
        return zip(names[0..<min(20, names.count)], descriptions[0..<min(20, descriptions.count)]).map { name, description in
            Person(name: name, description: description, avatar: person.avatar)
        }
    }
    
    /// A shrinker that uses every combination of shrunk name/person.
    /// This is generally not necessary and leads to very long run times in case the test fails
    public static func shrink(_ person: Person) -> [Person] {
        return String.shrink(person.name).forAll { name in
            String.shrink(person.description).map { description in
                return Person(name: name, description: description, avatar: person.avatar)
            }
        }
    }
}

class PersonTests: XCTestCase {

    func testLayout() {
        let arguments = CheckerArguments(replay: (StdGen(167855870, 8779), 34))

        property("All subview are contained within the Card's bounds", arguments: arguments) <- forAllShrink(Person.arbitrary, shrinker: Person.shrinkSimple) { (person: Person) in
            let card = PersonCard(viewModel: person)
            /// This is necessary to ensure that all the views within `Card` are layed out properly
            let view = UIView()
            view.addSubview(card)
            view.layoutIfNeeded()
            return card.subviews.all { card.bounds.contains($0.frame) }
        }
    }
}
