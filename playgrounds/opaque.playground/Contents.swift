import Foundation

public protocol SomethingHidden {
    func test() -> Bool
}

struct HiddenImplementation: SomethingHidden {
    func test() -> Bool {
        true
    }
}

public enum Builder {
    static func make() -> some SomethingHidden {
        HiddenImplementation()
    }
}

let something = Builder.make()
print(something.test())

struct AnotherHiddenImplementation: SomethingHidden {
    func test() -> Bool {
        false
    }
}

public enum AnotherBuilder {
    static func make(_ value: Bool) -> SomethingHidden {
        value ? HiddenImplementation() : AnotherHiddenImplementation()
    }
}

let somethingElse = AnotherBuilder.make(false)
print(somethingElse.test())

// Opaque on the rescue

protocol Container {
    associatedtype Item
    var count: Int { get }
    subscript(_: Int) -> Item { get }
}

extension Array: Container {}

/*
 // Error: Protocol with associated types can't be used as a return type.
 func makeProtocolContainer(item: some Any) -> Container {
     [item]
 }

 // Error: Not enough information to infer C.
 func makeProtocolContainer<C: Container>(item: some Any) -> C {
     [item]
 }
 */

func makeProtocolContainer(item: some Any) -> some Container {
    [item]
}

// any

protocol Machin {}

class Truc {
    var machin: any Machin
    init() {
        machin = Machin1()
    }

    func `switch`() {
        machin = Machin2()
    }
}

class TrucGeneric<T: Machin> {
    var machin: T
    init(machin: T) {
        self.machin = machin
    }
}

struct Machin1: Machin {}
struct Machin2: Machin {}

let truc1 = Truc(machin: Machin1())
truc1.switch()
let truc2 = TrucGeneric(machin: Machin1())
truc2.machin = Machin2()
