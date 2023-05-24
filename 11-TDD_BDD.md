# TDD et BDD

## TDD

Dans la partie précédente nous avons abordés les Tests Unitaires (TU). Dans cette partie nous allons abordé une méthode de codage qui utilise le principe de TU pour assurer que tout code produit est totalement couvert.

Une des définition de *code legacy* est : un code non couvert par des TUs.

Pour résoudre le problème du code legacy, certains.es développeureuses ont mis en place le principe du TDD. Pour résumer : **Test first**.

En TDD (Test Driven Development), avant d'écrire du code vous devez écrire un test. Ce test écrit, vous devez vérifier qu'il échoue. Ensuite, vous devez fixer cet échec en écrivant le minimum de code possible. Une fois le test réussi, vous êtes autorosé à refactoriser votre code pour le rendre plus propre (sans casser les TUs évidemment).

Cette méthode a l'avantage de produire du code qui est testé en permannece et à 100% donc avec un risque de régression largement diminué. Son seul désavantage est qu'elle nécessite de l'expérience et un peu plus de temps (en général de 15 à 30% de temps en plus). Elle produit aussi du code en théorie minimaliste.

Exemple :

Je dois écrire une fonction `sum`. 

*Dans cet exemple, nous allons faire du TDD pur (en respectant totalement la méthode. Il est clair que dans la réalité on passe certaines étapes - notamment les premières).*

J'écris d'abord un premier test, sans écrire aucun code :

```swift
func testSum1() throws {
    // arrange
    // act
    // assert
    XCTAssertEqual(sum(2, 3), 5)
}
```

l'IDE me dit avant de pouvoir lancer une compilation que la méthode `sum` n'existe pas (dans la réalité on passe cette étape en écrivant une méthode `sum` vide).

je peux donc écrire la méthode `sum` pour que monj test compile (la non-compilation est considérée comme un fail :-))

```swift
func sum(_: Int, _: Int) -> Int {
    0
}
```

Je lance mes TUs, le test `testSum1()` fail, je peux donc fixer mon code. Attention, je dois fixer au plus simple !

```swift
func sum(_: Int, _: Int) -> Int {
    5
}
```

Mes TUs passent, je ne peux plus modifier le code. je peux éventuellement refactorer mais dans notre cas c'est inutile.

Pour modifier le code je dois écrire un nouveau test.

```swift
func testSum2() throws {
    // arrange
    let x = 2
    let y = 5
    let expectedResult = 7
    // act
    let result = sum(x, y)
    // assert
    XCTAssertEqual(result, expectedResult)
}
```

Ce TU casse, je peux écrire du code (au plus simple). Pour l'exemple voici le code que je trouve le plus simple (je sais...) :

```swift
func sum(_: Int, _ y: Int) -> Int {
    y == 5 ? 7 : 5
}
```

Mes TUs passent, je couvre donc la totalité de mes cas.

Pour le principe, on notera que ce code :

```swift
func sum(_ x: Int, _: Int) -> Int {
    x == 2 ? 7 : 5
}
```

semble tout aussi valide que le précédent, mais il casse le premier test, il n'est donc pas valide.

Pour terminer, si je veux continuer de modifier ma méthode, je dois écrire un nouveau test. Le voici :

```swift
func testSum3() throws {
    // arrange
    let x = Int.random(in: 0..<20)
    let y = Int.random(in: 0..<20)
    let expectedResult = x + y
    // act
    let result = sum(x, y)
    // assert
    XCTAssertEqual(result, expectedResult)
}
```

Ce test semble intéressant. En général il fail avec le code actuel, mais parfois non. Si, par hasard, je tombe sur 2 et 7 dans mon random, alors le test passe. C'est un problème, parce qu'alors je ne suis pas autorisé à ajouter du code. Dans la réalité, on s'autoriserait à modifier le code. En théorie, on devrait ajouter un nouveau test... (ici, je vais modifier mon test. la modification de test est autorisée mais on doit faire attention car elle peut générer certains problèmes).

```swift
func testSum3() throws {
    // arrange
    let x = Int.random(in: 3..<20)
    let y = Int.random(in: 8..<20)
    let expectedResult = x + y
    // act
    let result = sum(x, y)
    // assert
    XCTAssertEqual(result, expectedResult)
}
```

Avec ce test, je suis certain qu'il ne passe jamais, je peux donc modifier mon code.

```swift
func sum(_ x: Int, _ y: Int) -> Int {
    x + y
}
```

Evidemment, cet exemple est très (trop ?) simple, mais on comprend le principe est l'intérêt du TDD :

- code couvert.
- code minimaliste (donc plus green !).
- code drivé par les tests et pas l'inverse.

J'ai (délibérement ?) omis une phase dans le TDD : le refactoring.

Il y a donc 3 phases en TDD :

1. écrire un test qui fail
1. écrire du code (le plus simple possible) qui permet au test de réussir
1. refactoriser son code (sans casser les tests)

La phase de refactoring permet parfois à certains développeur.euses de masquer des modifications... Le refactoring se veut "honnête". C'est une opportunité de modifier un naming, enlever une duplication, reformuler un commentaire ou rendre le code plus explicite. Il ne s'agit pas de tout transformer parce qu'on a passé les TUs...

## BDD

Le BDD (Behaviour Driven Development) ressemble fortement au TDD. La véritable (et importante) différence est que les tests ne sont pas écrits de la même manière et couvrent du comportement.

### Test Unitaire vs Test de comportement

La différence peut parfois être très ténue entre un test de comportement et un test unitaire (dans l'exemple précédent, si le but de notre app est de proposer une somme alors notre test unitaire serait presque un test de comportement). Pour tenter d'être plus synthétique, un test de comportement peut traverser des couches de developpement et tester des "choses" plus grandes. Un test untaire testera souvent une méthode spécifique, une fonction pure. L'autre grande différence est que les tests de comportements sont écrits en Gherkin, un langage compréhensible par d'autres personnes que les développeur.euses. Ils sont même normalement (parfois) rédigés par les testeur.euses ou les Business Analysts.

Dans la méthodologie "3 amigos", ils sont idéalement le résultat final de la réunion de présentation.

Exemple de fichier Gherkin :

```
Feature: Guess the word

  # The first example has two steps
  Scenario: Maker starts a game
    When the Maker starts a game
    Then the Maker waits for a Breaker to join

  # The second example has three steps
  Scenario: Breaker joins a game
    Given the Maker has started a game with the word "silky"
    When the Breaker joins the Maker's game
    Then the Breaker must guess a word with 5 characters
```

On voit bien que le principe fondamental est le même (3 phases principales : arrange, act, assert en TDD, Given, When, Then en Gherkin).

L'avantage de Gherkin réside dans sa lisibilité pour toustes (pas uniquement les développeur.euses). Il dispose aussi d'un dictionnaire de mots clés, au delà des 3 cités précedemment.

### BDD

Dans la réalité, le BDD est un peu plus complexe que le TDD, en particulier parce qu'il nécessite des librairies d'analyse des Gherkins en plus de la librairie XCTest. Ces librairies sont parfois peu maintenues et peuvent poser des problèmes...

Pour le reste, le principe reste le même : on écrit un test Gherkin, il faile, on fixe le code pour que le test passe, on refactorise le cas échéant.

Outre le testing, le BDD permet aussi de générer ce qu'on appelle souvent une *documentation vivante* (voir `Pickles`), c'est à dire une documentation de votre application générée à partir des scénarii écrits en Gherkin. C'est un des gros avantages du BDD s'il est bien mis en place, la documentation fonctionnelle d'un code étant, en général, une chose assez peu maintenue dans le temps (quand elle existe...!).

Voir: https://cucumber.io/docs/gherkin/reference/

Librairies de BDD iOS :

- https://github.com/kiwi-bdd/Kiwi
- https://github.com/net-a-porter-mobile/XCTest-Gherkin

## Remarque

Dans la réalité, on utilise généralement les 2 types de tests : Gherkin et unitaire.

Gherkin pour le comportement et le fonctionnel, Unitaire pour le structurel.