# Async/Sync, Multi threading

## Asynchronous

Il est fort probable que vous deviez travailler avec des systèmes qui ne sont pas synchrones, c'est à dire des systèmes dont le temps de réponse n'est pas forcément connu et qui pourraient répondre avec un ordre différent.

On résume souvent ce concept avec la notion de *concurrence*. Par concurrence on définit (pour la suite), tout type de code qui agit en parallèle d'un autre et/ou de manière asynchrone. On notare en outre que l'arrivée du multi-threading a amplifié la notion de code asynchrone et qu'on devrait désormai tout déveloper dans ce sens afin d'éviter toute forme de course de concurrence (race concurrency).

Même s'il est possible de résoudre les problèmes de concurrence avec des closures en Swift, les closures rendent le code compliqué à lire (nested closures) et génèrent de nombreux bugs. Il est désormais possible de travailler avec un système de type *asynchronous code*. Le code asynchrone utilise la notion de Task, async et await.

Exemple de closures :

```swift
listPhotos(inGallery: "Summer Vacation") { photoNames in
    let sortedNames = photoNames.sorted()
    let name = sortedNames[0]
    downloadPhoto(named: name) { photo in
        show(photo)
    }
}
```

On voit bien le problème de nested closures.

Avec le principe d'async/await on peut le transformer en ceci :

```swift
let photoNames = await listPhotos(inGallery: "Summer Vacation")
let sortedNames = photoNames.sorted()
let name = sortedNames[0]
let photo = await downloadPhoto(named: name)
show(photo)
```

L'intérêt de ce code est qu'il est plus facile à lire et qu'il indique clairement son intention.

Le code asynchrone nécessite des architectures le plus stateless possible et renforce l'usage d'éléments immutables et de fonctions pures. Il nécessite aussi une structure de tests unitaires parfois complexe surtout si on a des dépendances fortes à des *trucs* ayant des états non fixes comme des singletons.

Il est assez facile de transformer du code existant vers du code asynchrone en l'encapsulant dans une Task au démarrage, mais en général, il faudra repenser tout ou partie du code pour le rendre véritablement *pensé* comme du code saynchrone.

## Actors

Swift a introduit la notion d'Actor qui permet de générer des sortes de classes qui sont asynchrones.

Exemple :

```swift
actor TemperatureLogger {
    let label: String
    var measurements: [Int]
    private(set) var max: Int

    init(label: String, measurement: Int) {
        self.label = label
        self.measurements = [measurement]
        self.max = measurement
    }
}

let logger = TemperatureLogger(label: "Outdoors", measurement: 25)
print(await logger.max) // Prints "25"
```

Dans cet exemple simple on constate que `max` est récupérer suite au set, on pourrait concevoir tout cela pour des webservices par exemple.

## Sendable

Le protocol `Sendable` renforce aussi le principe de concurrence. Il est explicité ici :

https://developer.apple.com/documentation/swift/sendable

https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/#Sendable-Types

Il n'a pas de demande spécifique mais il force l'immutabilité d'une structure, d'une classe, d'une closure. Il est intéressant pour certifier que votre code est *concurent safe*.


*(Les exemples ci-dessus proviennent de : https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/)*

