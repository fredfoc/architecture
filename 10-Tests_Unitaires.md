# Tests unitaires

## Définition

Un test unitaire est un bout de code qui permet de tester le code écrit pour votre application.

Exemple :

```swift
func test_RemoveQueryShouldHaveSpecificEntryInQuery() throws {
    //arrange
    let key = "key"
    let service = "service"
    //act
    let query = try QueryRemove(identifier: MockSecureStoreIdentifier(service: service, group: nil), key: key)
    //assert
    XCTAssertEqual(query.query[String(kSecClass)] as! CFString, kSecClassGenericPassword)
    XCTAssertEqual(query.query[String(kSecAttrService)] as! String, service)
    XCTAssertEqual(query.query[String(kSecAttrAccount)] as! String, key)
}

```

Dans ce test, on vérifie que la `query` est correctement structurée. Le test est structuré en 3 étapes : arrange, act, assert.

Dans la phase `arrange`, on prépare les conditions du test. Dans la phase `act` on joue le code qu'on a préparé. Dans la phase `assert` on vérifie le résultat attendu.

Outre qu'un test unitaire vous permet de vérifier que votre code fait correctement ce qui est prévu qu'il réalise, il permet aussi de vous éviter des régressions lorsque vous changer du code.

Le TDD (voir 11-TDD/BDD) pousse la logique encore plus loin en produisant des tests avant tout code.

Les Tests Unitaires peuvent aussi aider lors d'un refacto.

## Code testable, Code Coverage, Mocks

Tous les codes ne sont pas testables. Par testable on entend que chaque morceau de code est couvert pas un test.

La couverture de code (Code Coverage) est un indicateur qui définit le pourcentage de code couvert. Il n'est pas toujours pertinent (on peut avoir un gros pourcentage de couverture de code et n'avoir testé que les parties inutiles du code - comme la UI par exemple -, ou avoir parcouru du code sans véritablement le tester).

Les codes difficilement testables contiennent souvent des side-effects, des singletons ou de l'état mal géré. On peut souvent rendre du code testable en appliquant les règles SOLID, notamment l'inversion de dépendances. En effet, l'inversion de dépendance permet d'injecter des mocks.

Un mock est un objet qui respecte un contrat définit mais dont on manipule l'état (renvoyer une erreur spécifique par exemple, ou un résultat précis qui permettra de vérifier le retour d'une méthode).

### Exemple de mise en place de TU

On veut tester unitairement ce code :

```swift
struct GroceryProduct: Decodable {}

class ManagerExercice {
    func decodeAndSave(from json: Data, to path: URL) -> Error? {
        do {
            try JSONDecoder().decode(GroceryProduct.self, from: json)
            try json.write(to: path)
            return nil
        } catch {
            return error
        }
    }
}
```

On peut écrire un test du type :

```swift
func testExample() throws {
    // arrange
    let grocery = GroceryProduct(name: "Test")
    let data = try! JSONEncoder().encode(grocery)
    let url = URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .appendingPathComponent("Resources/test.txt")
    // act
    let result = ManagerExercice().decodeAndSave(from: data, to: url)
    // assert
    XCTAssertNil(result)
}
```

Ce test ne couvre pas tout le code (ici on ne teste que le fait qu'il n'y a pas d'erreur `result == nil`). Nous pourrions écrire un autre test comme suit :

```swift
func testErreurExample() throws {
    // arrange
    let data = "bad json".data(using: .utf8)
    let url = URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .appendingPathComponent("Resources/test.txt")
    // act
    let result = ManagerExercice().decodeAndSave(from: data!, to: url)
    // assert
    XCTAssertNotNil(result)
}
```

Ces deux tests sont intéressants mais ils masquent le problème principal de l'utilisation de `JSONDecoder().decode` et de la méthode `write` de Data, méthodes qu'il est impossible de "mocker". On ne peut donc pas prévoir un résultat spécifique (on contourne en mettant un faux json pour faire "failer" le `decode` ce qui nous permet d'entrer dans le `catch`). Par contre, on constate que nous avons 100% de code coverage (même si nous ne testons pas véritablement toute la logique du code - ici un.e développeureuse pourrait changer la partie concernant le `write` sans que les tests ne cassent ce qui est un problème.).

Nous soulevons donc deux choses :

- 100% de code coverage ne signifie pas que tout votre code est testé.
- écrire des tests dans un code mal architecturé est très compliqué, voir parfois impossible.

L'utilisation de mocks permet de prévoir les résultats. Toutefois, pour pouvoir injecter des mocks dans notre code il nous faut inverser les dépendances de notre code à tous les éléments nécessaires (ici `JSONDecoder` et `Data`).

On pourrait réécrire le code comme suit.

Exemple :

```swift
protocol Decoder {
    @discardableResult
    func decode<T>(_ type: T.Type, from data: Writable) throws -> T where T: Decodable
}

protocol Writable {
    func write(to url: URL) throws
}

extension Data: Writable {
    func write(to url: URL) throws {
        try write(to: url, options: [])
    }
}

extension JSONDecoder: Decoder {
    @discardableResult
    func decode<T>(_ type: T.Type, from data: Writable) throws -> T where T: Decodable {
        guard let data = data as? Data else {
            fatalError("oups")
        }
        return try decode(type, from: data)
    }
}

class ManagerExercice {
    func decodeAndSave(from json: Writable, to path: URL, decoder: Decoder = JSONDecoder()) -> Error? {
        do {
            try decoder.decode(GroceryProduct.self, from: json)
            try json.write(to: path)
            return nil
        } catch {
            return error
        }
    }
}
```

Nos tests précédents passent toujours (la signature n'a pas changée). Cependant on peut maintenant écrire des tests en intégrant des mocks.

Exemple :

```swift
func testExampleSuccess() throws {
    // arrange
    class MockWritable: Writable {
        func write(to _: URL) throws {}
    }
    class MockDecoder: Decoder {
        func decode<T>(_: T.Type, from _: TestsUnitaires.Writable) throws -> T where T: Decodable {
            guard let grocery = GroceryProduct(name: "Fred") as? T else {
                fatalError()
            }
            return grocery
        }
    }
    let data = MockWritable()
    let decoder = MockDecoder()
    // act
    let result = ManagerExercice().decodeAndSave(from: data, to: URL(fileURLWithPath: #file), decoder: decoder)
    // assert
    XCTAssertNil(result)
}

func testErreurDecoder() throws {
    // arrange
    class MockWritable: Writable {
        func write(to _: URL) throws {}
    }
    enum MyError: Error {
        case test
    }
    class MockDecoder: Decoder {
        func decode<T>(_: T.Type, from _: TestsUnitaires.Writable) throws -> T where T: Decodable {
            throw MyError.test
        }
    }
    let data = MockWritable()
    let decoder = MockDecoder()
    // act
    let result = ManagerExercice().decodeAndSave(from: data, to: URL(fileURLWithPath: #file), decoder: decoder)
    // assert
    XCTAssertTrue(result as? MyError == MyError.test)
}
```   

Ces tests sont parfaitement prédictibles. Nous avons inversé les dépendances dans la méthode `decodeAndSave` de `ManagerExercice` ce qui permet de rendre cette méthode prédictible.

On pourra reprocher au nouveau code d'être plus complexe à lire, plus verbeux, ce qui est vrai. Cependant, si l'on devait changer la logique de ce code, nos tests unitaires nous permettraient de savoir si nos changements vont créer des régressions ou pas ce qui est le but d'un test unitaire.

### Exercices

- Rédiger le dernier test qui permet de voir que la méthode `decodeAndSave` retourne bien l'erreur de la méthode `write` sur Writable.
- Prendre un bout de code d'une application et le couvrir par des TU



