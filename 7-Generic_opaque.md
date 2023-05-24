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

## Opaque Type

Avec les generics vous permettez à l'utilisateur de choisir le type qu'il va utiliser. Avec les types opaques c'est l'inverse, vous présentez un protocol qui cache le typage à l'utilisateur mais c'est vous qui choisissez le typage et le compilateur va optimiser la compilation en fonction de ce typage (il effacera ensuite, à la compilation, le protocol pour le remplacer par le type correct).

Exemple :

```swift
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
print(something.test()) // print true
```

Le `Builder` retourne quelque chose du type `SomethingHidden`. Le compilateur sait qu'il s'agit d'un `HiddenImplementation` mais pas l'utilisateur du `Builder`.

### Différence entre protocol type et opaque type

Dans l'exemple ci-dessus, on aurait pu mettre :

```swift
public enum Builder {
    static func make() -> SomethingHidden {
        HiddenImplementation()
    }
}
```

Ici le `Builder` indique qu'il retourne quelque chose du type `SomethingHidden` comme précedemment, à la différence que le compilateur ne va pas inférer le type renvoyé ce qui peut mener à différentes problèmes. En contre-partie vous gagnez évidemment en flexibilité puisque vous pouvez renvoyer différentes implémentations (ce que ne permettrez pas le type opaque).

Exemple :

```swift
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
```

Nous n'aurions pas pu utiliser `some SomethingHidden` puisque le compilateur ne sait choisir entre `HiddenImplementation` et `AnotherHiddenImplementation`.

Ce que les types opaques permettent aussi de résoudre sont les cas suivants :

```swift
protocol Container {
    associatedtype Item
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}
extension Array: Container { }
```

Vous ne pouvez pas utiliser ce protocol cmme retour de fonction ou comme contrainte sur des generics.

```swift
// Error: Protocol with associated types can't be used as a return type.
func makeProtocolContainer(item: some Any) -> Container {
    [item]
}

// Error: Not enough information to infer C.
func makeProtocolContainer<C: Container>(item: some Any) -> C {
    [item]
}
```

Swift ne pourra pas inférer correctement le type de retour puisque Container a un associated type. Il suffit de passer par des types opaques comme suit :

```swift
func makeProtocolContainer(item: some Any) -> some Container {
    [item]
}
```

Dans ce cadre, Swift infère le type en utilisant le type de `item`.

On rencontre régulièrement ce problème avec des Protocols contenant des associated types (le célèbre *Protocol can only be used as a generic constraint*)

Rem :

Depuis Swift 5.7, on peut remplacer la notation generics par l'utilisation de `some` comme dans l'exemple ci-dessous :

```swift
// generics
func printElement<T: CustomStringConvertible>(_ element: T) {
    print(element)
}
```

```swift
// some
func printElement(_ element: some CustomStringConvertible) {
    print(element.description)
}
```

### any

https://forums.swift.org/t/improving-the-ui-of-generics/22814#heading--limits-of-existentials
https://github.com/apple/swift-evolution/blob/main/proposals/0335-existential-any.md#any-and-anyobject
https://www.avanderlee.com/swift/anyobject-any/


Exemple intéressant :

```swift
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
truc1.switch() //Pas d'erreur
let truc2 = TrucGeneric(machin: Machin1())
truc2.machin = Machin2() //Erreur de typage
```

`Truc` est existentiel. On ne connait pas la véritable valeur de `machin`, on sait juste que c'est un `Machin`. On ne lui fournit pas spécifiquement, il en fait ce qu'il veut.

`TrucGeneric` est universel, il marche avec tous les types respectant `Machin`, mais il ne renvoit qu'une seule sorte de `Machin`. On lui fournit ce `Machin` de l'extérieur.



