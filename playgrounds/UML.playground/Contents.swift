import Foundation

// Exemple 1
struct B {
    let name: String
    let c: C
}

struct C {
    let family: String
}

class A {
    let b: B
    init(b: B) {
        self.b = b
    }

    func test() {
        print(b.name)
    }
}

// Exemple 2
protocol Employeur {
    var salaire: Int { get }
    func prime(anciennete: Int) -> Int
}

class Entreprise {}

extension Entreprise: Employeur {
    var salaire: Int {
        10000
    }

    func prime(anciennete: Int) -> Int {
        salaire * anciennete
    }
}

// Exemple 3

struct Uno {
    let due: Due
}

struct Due {
    let tree: Tree
}

class Tree {
    var uno: Uno?
}

let tree = Tree()
let due = Due(tree: tree)
let uno = Uno(due: due)
tree.uno = uno

// Exemple 4

class Truc: Machin {
    var bidule: Bidule?
    func truc() -> Truc {
        self
    }
}

protocol Machin {
    func truc() -> Truc
}

class Bidule {
    var machin: Machin?
}

let truc = Truc()
let bidule = Bidule()
bidule.machin = truc
truc.bidule = bidule
print(bidule.machin?.truc())
