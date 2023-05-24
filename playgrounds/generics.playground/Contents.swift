import Foundation

// Exemple

// Non generic
struct IntStack {
    var items: [Int] = []
    mutating func push(_ item: Int) {
        items.append(item)
    }

    mutating func pop() -> Int {
        items.removeLast()
    }
}

struct StringStack {
    var items: [Int] = []
    mutating func push(_ item: Int) {
        items.append(item)
    }

    mutating func pop() -> Int {
        items.removeLast()
    }
}

// Generic

struct Stack<Element> {
    var items: [Element] = []
    mutating func push(_ item: Element) {
        items.append(item)
    }

    mutating func pop() -> Element {
        items.removeLast()
    }
}

// Generic and Constraint

// Non generic
struct FilterInt {
    let content: [Int]
    func contains(_ value: Int) -> Bool {
        var isIn = false
        content.forEach { item in
            if item == value {
                isIn = true
            }
        }
        return isIn
    }
}

// Generic

struct Filter<T: Equatable> {
    let content: [T]
    func contains(_ value: T) -> Bool {
        var isIn = false
        content.forEach { item in
            if item == value {
                isIn = true
            }
        }
        return isIn
    }
}

// Associated Types

// Exemple

protocol DeviceFilterPredicate {
    associatedtype Device
    func shouldKeep(_ item: Device) -> Bool
}

struct Laptop {
    let box: Int
}

struct BoxFilter: DeviceFilterPredicate {
    var box: Int
    func shouldKeep(_ item: Laptop) -> Bool {
        item.box == box
    }
}

// Exemple Constraints

protocol Weighable {
    var mass: Int { get }
}

protocol WeighFilterPredicate {
    associatedtype Item: Weighable
    func shouldKeep(_ item: Item) -> Bool
}

// Exercice

enum Color {
    case yellow
    case blue
    case red
}

enum Size {
    case small
    case medium
    case big
}

struct PaintBucket: CustomStringConvertible {
    var name: String
    var color: Color
    var size: Size

    var description: String {
        "(\(name) \(color) \(size))"
    }
}

// Answer 1

func filtering(_ paintBuckets: [PaintBucket], by size: Size) -> [PaintBucket] {
    paintBuckets.filter { $0.size == size }
}

let paintBuckets = [
    PaintBucket(name: "a", color: .red, size: .small),
    PaintBucket(name: "b", color: .blue, size: .medium),
    PaintBucket(name: "c", color: .yellow, size: .big),
    PaintBucket(name: "d", color: .blue, size: .small),
]

let filteredPaintBuckets = filtering(paintBuckets, by: .small)
print(filteredPaintBuckets)

// Answer 2

protocol FilterPredicate {
    associatedtype Item
    func keep(_ item: Item) -> Bool
}

struct SizeFilter: FilterPredicate {
    var size: Size

    func keep(_ item: PaintBucket) -> Bool {
        item.size == size
    }
}

struct ColorFilter: FilterPredicate {
    var color: Color

    func keep(_ item: PaintBucket) -> Bool {
        item.color == color
    }
}

func filtering<F: FilterPredicate>(
    _ laptops: [PaintBucket],
    by filter: F
) -> [PaintBucket] where PaintBucket == F.Item {
    laptops.filter { filter.keep($0) }
}

print(filtering(paintBuckets, by: SizeFilter(size: .small)))
print(filtering(paintBuckets, by: ColorFilter(color: .red)))

// Answer 3

protocol Sizeable {
    var size: Size { get }
}

protocol Colorable {
    var color: Color { get }
}

extension PaintBucket: Sizeable {}
extension PaintBucket: Colorable {}

struct SprayPaint: CustomStringConvertible {
    var name: String
    var color: Color
    var size: Size

    var description: String {
        "(\(name) \(color) \(size))"
    }
}

extension SprayPaint: Sizeable {}
extension SprayPaint: Colorable {}

struct GenericSizeFilter<T: Sizeable>: FilterPredicate {
    var size: Size

    func keep(_ item: T) -> Bool {
        item.size == size
    }
}

struct GenericColorFilter<T: Colorable>: FilterPredicate {
    var color: Color

    func keep(_ item: T) -> Bool {
        item.color == color
    }
}

// Define the new filter function.
func filtering<F: FilterPredicate, T>(
    _ elements: [T],
    by filter: F
) -> [T] where T == F.Item {
    elements.filter { filter.keep($0) }
}

let sprayPaints = [
    SprayPaint(name: "a", color: .red, size: .small),
    SprayPaint(name: "b", color: .blue, size: .medium),
    SprayPaint(name: "c", color: .yellow, size: .big),
    SprayPaint(name: "d", color: .blue, size: .small),
]

print(filtering(paintBuckets, by: GenericSizeFilter(size: .small)))
print(filtering(paintBuckets, by: GenericColorFilter(color: .red)))
print(filtering(sprayPaints, by: GenericSizeFilter(size: .small)))
print(filtering(sprayPaints, by: GenericColorFilter(color: .red)))
