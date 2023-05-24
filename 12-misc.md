# Misc.

## Composable

Composable (https://github.com/pointfreeco/swift-composable-architecture) est une architecture s'inspirant de Redux et ELM, développée en Swift.

Compasable peut être considérée comme un framework, une fois qu'on l'a choisie, impossible (ou très difficile) de s'en défaire, à l'instar de ReactNative ou de Flutter. C'est un choix à faire. On peut, par ailleurs, transiter vers une architecture Composable.

Personnellement, je trouve ça risqué, mais le principe est intéressant, notamment dans sa gestion des side effects et dans le positionnement du state. Pour ceux qui connaissent Redux, on est en terrain connu.

Je ne m'attarderai pas sur cette partie, elle est très bien expliquée sur le repo Composable (et les deux personnes qui en sont à l'origine sont de très bons développeurs).

## Refactoring

Tout ce qui a été dit précédemment permet aussi d'aborder le refactoring plus facilement. Lorsque vous devez travailler dans du legacy code, la première chose est de tenter de positionner des tests unitaires autour, en définissant des sortes de grosses blackboxes que vous pouvez couper du reste via la mise en place de protocols (inversion de dépendance).

Ca n'est pas toujours très facile, mais ça se fait et avec la pratique on finit par travailler en orienté protocol assez facilement (et même avec plaisir !). L'utilisation de génériques permet aussi de refactorer du code en enlevant de la duplication.

Des outils comme SonarQube vous permettent aussi d'analyser le code et de cerner les parties à refactorer. Les équipes SonarQube travaillent d'ailleurs sur la mise en place d'outils d'analyse d'architecture au delà de leurs outils d'analyse de code à proprement parlé (à surveiller).

## Swift

Swift évolue en permanence (à la date de la rédaction on parle de Swift 6 qui arrive). Ces évolutions font changer les architectures (avant Combine ou RxSwift on mettait des delegate partout !). Suivre l'évolution de Swift n'est pas seulement un impératif pour votre code mais aussi pour votre architecture. Si cette dernière est monolithique (en un seul gros bloc), on se doute qu'elle aura du mal à suivre les évolutions de Swift (si vous avez tout mis dans un UIViewController, passer vers SwiftUI ne va pas être une partie de plaisir...).

## Revue de Code

La revue de code est un outil particulièrement intéressant pour faire évoluer/partager votre architecture. Appliquer l'adage : "Bienveillant avec les personnes et dur avec le code" durant des sessions de partage et d'examen de votre code base sera toujours profitable. En tant qu'architecte vous pourrez voir où votre archi pêche (difficile à comprendre, non adaptée à certains uses-cases, etc), en tant que développeur, vous pourrez trouver des opportunités de compréhension, de changement et d'amélioration.

Une bonne revue de code (entre autres choses) :
- dure moins d'une heure
- est cadrée par un time keeper
- mène à des décisions partagées

## Tech leader

Le rôle de tech leader devrait être un rôle partagé par l'équipe, le pire étant que les décisions soient prises par une seule personne avec le résultat classique d'une dictature. Fuyez les personnes qui se présentent avec un titre ! Nous sommes toustes des développeur.euses.

## Anarchie

L'anarchie est la seule réponse politique adéquate. Fuck la hiérarchie, bienvenue à la liberté.

## Patriarcat

Le patriarcat tue tout, les hommes en les rendant violents, toxiques, bêtes, stupides, les femmes en les violant, en les dominant, en les empêchant de se développer pleinement, la nature en la massacrant pour le profit et la bêtise. Soyez bienveillant.es, non toxiques, tolérant.es, chassez vos comportements patriarcaux, ils sont partout surtout là où on n'y pense pas. Ils sont dans nos codes, nos algorithmes, nos pratiques. Ils détruisent le monde, la nature, les personnes.

## Capitalisme

Le capitalisme c'est de la merde patriarcale au profit d'une minorité de crétin.es. Partagez vos idées, vos connaissances !

## Ecologie/Green IT

Pensez aux prochaines générations, pensez green, optimisez vos codes, faites du télétravail, travaillez moins pour gagner moins d'argent mais plus de temps, ne tondez plus vos pelouses, roulez vous dedans, lisez des livres puis donnez les à d'autres, arrétez vos voitures, prenez des vacances, parlez avec vos enfants, faites l'amour dans l'herbe, portez des kilts, du vernis à ongles, oubliez le genre, soyez gentil.les.

Bisous.