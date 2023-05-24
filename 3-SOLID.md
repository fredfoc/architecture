# SOLID

## Definition

SOLID est l'acronyme pour Single Responsability Principle, Open Closed Principle, Liskov Substitution Principle, Interface Segregation Principle, Dependency Inversion Principle. C'est un des coeurs du clean code.

La mise en application des ces 5 principes très simples permet d'éviter un grand nombre de problème dans le code et de mettre en place un code respectant (généralement) le clean code.

## Single Responsability Principle (SRP)

Une classe (ou un struct, ou un machin) devrait n'avoir qu'une seule responsabilité (ne faire qu'une seule "chose" mais bien).

Ce que ça ne veut pas dire :
- ça ne signifie pas n'avoir qu'une seule méthode ou qu'une seule variable
- ça ne signifie pas être courte (même si c'est mieux quand un élément n'est pas trop long)
- ça ne signifie pas qu'une chose est forcément simple (même si c'est mieux de séparer en petites choses simples une grande chose compliquée)

Ce que ça peut vouloir dire :
- qu'une classe qui fait trop de choses c'est mal
- qu'un struct qui aurait trop de responsabilité devient difficile à maintenir

Exemple :

Ce code n'est pas compliant parce que le struct Car fait beaucoup trop de choses.

```swift
//SRP

// Non compliant

struct Car {
    private var fuel: Int = 0
    private var speed: Int = 0
    private var internalTemp: Int = 20
    func displayFuel() -> Int {
        fuel
    }
    func displaySpeed() -> Int {
        speed
    }
    mutating func accelerate() {
        speed += 1
    }
    mutating func deccelerate() {
        speed -= 1
    }
    
    mutating func increaseInternalTemp() {
        internalTemp += 2
    }
}
```

Ce code est plus compliant parce que les responsabilités sont maintenant partagées entre des éléments plus petits et plus faciles à maintenir.

```swift
// Compliant

struct Engine {
    private(set) var speed: Int = 0
    mutating func accelerate() {
        speed += 1
    }
    mutating func deccelerate() {
        speed -= 1
    }
}

struct FuelTank {
    private(set) var fuel: Int = 0
}

struct Heater {
    private(set) var internalTemp: Int = 20
    mutating func increaseInternalTemp() {
        internalTemp += 2
    }
}

struct Car {
    let tachimetre: Engine
    let fuelTank: FuelTank
    let heater: Heater
}
```


## Open Closed Principle (OCP)

Open to extension, Closed to modification.

Une classe (ou un struct, ou un machin) devrait être extensible facilement mais on ne devrait jamais le.a modifier. En effet, si on le.a modifie (et que d'autres dépendent d'iel), alors ça aura un impact sur ces autres, or on veut éviter que des ajouts de fonctionnalités aient un impact (crée des régressions) sur l'existant.

OCP renforce l'utilisation des protocols et du polymorphisme.

Exemple :

Dans ce code, si j'ajoute un nouveau case dans l'enum, je vais devoir modifier le struct Bicycle.

```swift
// Non compliant

enum BicycleType {
    case twoWheel
    case monoWheel
    case electrical
}

struct Bicycle {
    let type: BicycleType
    var rentingPrice: Int {
        switch type {
        case .twoWheel:
            return 10
        case .monoWheel:
            return 12
        case .electrical:
            return 15
        }
    }
}
```

Ici, si j'ajoute un nouveau case, je n'aurai qu'à créer un struct pour ce case, sans rien modifier au reste du code.

```swift

// Compliant

enum BicycleType {
    case twoWheel
    case monoWheel
    case electrical
}

protocol Bicycle {
    var type: BicycleType { get }
    var rentingPrice: Int { get }
}

struct TwoWheelBicycle: Bicycle {
    let type = BicycleType.twoWheel
    var rentingPrice: Int { 10 }
}
```

## Liskov Substitution Principe (LP)

D'après une règle élaborée par Barbara Liskov : on doit respecter le contrat définit, surtout dans le cadre d'un héritage, mais aussi dans le cadre de l'implémentation d'un protocol.

Exemple :

```swift
// Non Compliant

protocol ANiceProtocol { }
struct StructA: ANiceProtocol { }
struct StructB: ANiceProtocol { }

func doSomething(_ with: ANiceProtocol) {
    switch with {
    case is StructA:
        fatalError()
    default:
        print("ok")
    }
}
```

Un autre exemple de code non compliant :

```swift
// Non Compliant

protocol Bird {
    func fly()
}

struct BlackBird: Bird {
    func fly() { print("I'm flying") }
}

struct Ostrich: Bird {
    func fly() { fatalError("won't fly") }
}
```

## Interface Segregation Principle (ISP)

Une interface (un protocol) ne devrait pas contenir trop de choses. Une classe (ou un struct, ou un machin) qui définirait un contrat devrait rendre ce contrat aussi minimaliste que possible et devrait éviter d'embarquer des choses inutiles par facilité.

Exemple :

```swift
// Non Compliant

protocol ATM {
    func deposit(amount: Int, account: Int)
    func withdrawal(amount: Int, account: Int)
    func balance(account: Int)
    func changePinCode(card: Int)
    func updateAddress(user: Int)
    func blockCard(id: Int)
    func contact(user: Int)
}

// Compliant

protocol Deposit {
    func deposit(amount: Int, account: Int)
}

protocol Withdrawal {
    func withdrawal(amount: Int, account: Int)
}

protocol AccountManagement {
    func balance(account: Int)
}

protocol CardManagement {
    func changePinCode(card: Int)
    func updateAddress(user: Int)
    func blockCard(id: Int)
    func contact(user: Int)
}
```

## Dependency Inversion Principle (DIP)

Voir la partie sur l'inversion de dépendance dans [UML](2-UML.md).