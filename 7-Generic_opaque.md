# Generic, Associatedtype, type opaque

## Generics

Les generics sont une des grandes forces de Swift. Ils permettent de rendre du code agnostique des éléments utilisés.

### Exemple

Supposons qu'on souhaite créer une collection de type Stack qui stockerait des éléments d'un certain type.

Sans les generics, on devrait créer autant de Stack que de types.

```swift
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
```

avec les generics, on peut faire ceci :

```swift
struct Stack<Element> {
    var items: [Element] = []
    mutating func push(_ item: Element) {
        items.append(item)
    }

    mutating func pop() -> Element {
        items.removeLast()
    }
}
```

Repris de : [Generics](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics)

Mais le plus intéressant dans les générics (hormis le fait qu'on ne duplique plus de code), c'est quo'n peut leur attribuer des contraintes.

### Mise en place de contrainte sur des Generics

Les contraintes dans les generics permettent de forcer le generic à être compliant avec des règles fixées par un procotol (à respecter le contrat fixé par le protocol). Les generics, associés à des contraintes par protocol sont un outil extrèmement puissant pour déveloper une architecture élégante, stable et facile à maintenir.

Attention toutefois, cela nécessite parfois d'être habitué à ce type d'utilisation.

Exemple :

```swift
//Non generic
struct FilterInt {
    let content:[Int]
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

//Generic

struct Filter<T> {
    let content:[T]
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
```

Cependant, la version generic de ce code (qui n'a rien d'optimal et n'est là que pour l'exemple - je sais qu'il existe une méthode `contains` sur `Array` :-)) ne compile pas parce T ne dispose pas de la méthode "==" (*Referencing operator function '==' on 'Equatable' requires that 'T' conform to 'Equatable'*).

Avec les contraintes, nous pouvons régler ce problème :

```swift
struct Filter<T: Equatable> {
    let content:[T]
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
```

**Les generics associés aux protocols sont un outil génial**.

## Associated Types

Les types associés sont une méthode pour rendre vos protocols plus souples et plus agnostiques de ce qu'ils utilisent.

Exemple

```swift
protocol DeviceFilterPredicate {
    associatedtype Device
    func shouldKeep(_ item: Device) -> Bool
}
```

Dans cet exemple, nous permettons à toute entité implémentant `DeviceFilterPredicate` de définir elle même ce que sera le type de Device.

Exemple d'implémentation :

```swift
struct Laptop {
    let box: Int
}

struct BoxFilter: DeviceFilterPredicate {
    var box: Int
    func shouldKeep(_ item: Laptop) -> Bool {
        item.box == box
    }
}
```

En faisant ceci nous devenons agnostique du type de Device.

*Remarque : `typealias Device = Laptop`n'est pas nécessaire. Swift sait inférer le type de Device en regardant la signature de `func shouldKeep(_ item: Laptop) -> Bool`.*

On peut évidemment définir des contraintes sur les Associated Type.

Exemple :

```swift
protocol Weighable {
    var mass: Int { get }
}

protocol FilterPredicate {
    associatedtype Item: Weighable
    func shouldKeep(_ item: Item) -> Bool
}
```

## Exercice

On peut associer les AssociatedType avec l'utilisation de Generics.

Tentons une approche avec un exercice :

Un magasin de peintures présente ses pots sur des étagères sous différents formats et avec différentes couleurs.

```swift
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
```

1. On veut filtrer les pots par taille : comment feriez-vous ?
1. On veut maintenant filtrer les pots par couleur, en conservant l'option par taille : comment feriez-vous ?
1. On ajoute un nouveau type de produit : les bombes de peinture avec les contraintes de taille et de couleur : comment feriez-vous pour conserver vos systèmes de filtres ? Implémentez :-).

```swift
struct SprayPaint: CustomStringConvertible {
    var name: String
    var color: Color
    var size: Size

    var description: String {
        "(\(name) \(color) \(size))"
    }
}
```

Réponses ici [Playground Generics](playgrounds/generics.playground)




