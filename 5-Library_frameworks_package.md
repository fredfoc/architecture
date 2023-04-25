# Library, frameworks, package manager (SPM, Cocoapods)

## Lib. vs FW
On distingue régulièrement les librairies des frameworks. Voici une façon (non officielle) de faire la différence :

On dit souvent qu'on construit autour d'un framework mais qu'on utilise une librairie. A titre d'exemple, Angular est un framework, React est une librairie (pourtant il est très difficile de migrer une app développée en React vers un autre framework).

En Swift, Combine est un framework (même si certains le considèrent comme une librairie), SwiftUI est une librairie.

Personnellement, j'ai tendance à dire qu'un framework se retrouvera au milieu de mon architecture (plus proche du centre de l'onion), tandis qu'une librairie sera à l'extérieur.

## Comment se "protéger" d'une lib ou d'un FW

Il est toujours intéressant de penser à se protéger d'un package (lib ou FW). Pour se faire on utilise évidemment l'inversion de dépendance (et l'injection de dépendance).

Exemple :

Avec une dépendance forte :

```swift
class Manager {
    // Strong dependency to Foundation/JSONDecoder
    let decoder = JSONDecoder()
    func printName(from json: Data) {
        let product = try? decoder.decode(GroceryProduct.self, from: json)
        print(product?.name ?? "oups")
    }
    
}

let manager = Manager()
manager.printName(from: json) // Prints "Durian"
```

Sans dépendance forte :

```swift
protocol JSONDecoderProtocol {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}

extension JSONDecoder: JSONDecoderProtocol { }

class Manager {
    let decoder: JSONDecoderProtocol
    // Dependency Injection
    init(decoder: JSONDecoderProtocol) {
        self.decoder = decoder
    }
    func printName(from json: Data) {
        let product = try? decoder.decode(GroceryProduct.self, from: json)
        print(product?.name ?? "oups")
    }
    
}

let manager = Manager(decoder: JSONDecoder())
manager.printName(from: json) // Prints "Durian"
```

### Exercice :

Dans le code suivant :

```swift
struct GroceryProduct: Codable {
    var name: String
    var points: Int
    var description: String?
}

class Manager {
    func decodeAndSave(from json: Data, to path: URL) throws {
        try JSONDecoder().decode(GroceryProduct.self, from: json)
        try json.write(to: path)
    }
}
```

1. Quelle(s) dépendance(s) inverseriez-vous ? Pourquoi ?
1. Inversez cette/ces dépendance(s).


## Gestionnaire de Packages

Un gestionnaire de packages est un utilitaire qui vous permet de gérer toutes vos librairies (numéro de version, dépendances, etc.).

Il existe 3 "gros" gestionnaires de package en iOS : Carthage, Cocoapods et le tout dernier SPM (Swift Package Manager).

Je ne ferai pas le tour de tous les pros et cons de chacun de ces gestionnaires :
- **Carthage** a l'avantage de compiler en amont (ce qui rend le temps de build plus rapide en général), mais il semble en large perte de vitesse.
- **Cocoapods** reste très répandu, cependant, il est très lourd, très intrusif (création d'un xcworspace) et nécessite parfois des fichiers de config un peu tordu.
- **SPM**, le tout dernier et soutenu par Apple (intégré dans XCode), dispose de nombreux avantages, dont notamment une meilleure intégration au niveau des Tests Unitaires et (évidemment) de XCode.

J'ai tendance à favoriser SPM, ne serait-ce que parce que si votre lib est bien construite (non dépendante à UIKit), alors vous pouvez facilement la tester en ligne de commande (`swift test`) et donc facilement sur une CI (le temps de build se trouve drastiquement réduit). Il existe cependant quelques problèmes, notamment quand votre projet est un xcworkspace ou que vous avez des targets multiples (il faut tout ajouter à la main). En outre, le principe de package en cours de développement est assez lourd (ajout d'un package local, retrait du package si il existe déjà, manipulation à refaire à chaque fois...).
