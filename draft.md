# Draft de Dragonfly

## Objectifs du jeu

C'est un sidescroller/shoot'em up. Le joueur incarne un véhicule qui embarque un certain nombre d'armes et doit éliminer/éviter les ennemis qui arrivent par la gauche de l'écran.

## Comment se déroule le jeu ?

Le jeu démarre sur un menu classique. Jouer/options/quitter.

Quand on clique sur jouer, on peut éventuellement choisir un nouveau ou plutôt il y a une histoire, des niveaux qui s'enchaînent. On peut éventuellement choisir de revenir dessus après (pas au tout début).

Donc l'histoire commence. On embarque et il y a un premier niveau assez simple qui permet de se faire la main. Petit à petit, d'autres ennemis apparaissent, qui ont chacun leurs caractéristiques. Le joueur devra construire des stratégies pour éliminer/éviter les ennemis. Il faudra faire du level-design pour concevoir ces niveaux en fonction des capacités des ennemis.

Il faut que ça soit fun, rythmé, avec des effets de son et pourquoi pas des effets visuels (destruction des ennemis qui partent en morceau, ou même simple explosion etc... pourquoi pas plein de couleurs?). À voir dans un second temps, une fois les mécaniques de base créées/implémentées.

## Que pourra faire le joueur ?

Le joueur peut/doit (en gros) :
- se déplacer verticalement (dans la limite de l'écran)
- se déplacer horizontalement (dans une limite acceptable?)
- tirer des projectiles (différentes armes envisageables : projectile ponctuel, projectile type laser (rayon continu instantané), projectiles radiaux (ex plusieurs projectils ponctuels tirés selon différents angles), etc).
- éviter de se faire toucher par les ennemis (jauge de vie)
- collecter des items (santé, armes, collectables...) qui défilent avec le reste (secondaire)

## Comment procéder ?

###### Phase 0 : réflexion préliminaire

- [ ] Poser les bases du jeu, les principes élémentaires
- [ ] Discuter de ces bases avec une personne tierce pour favoriser la création d'idées neuves dès le départ
- [ ] Réfléchir à une ambiance de jeu générale : coloré/terne, joyeux/grave, épique/apocalyptique, géométrique-minimal/étoffé...
- [ ] Entretenir un *draft* qui résume les objectifs et la timeline du processus du développement.

###### Phase 1 : premier prototype

- [ ] Coder un environnement de base
- [ ] Coder le déplacement du joueur
- [ ] Coder une arme basique qui tire des projectiles ponctuels et gère les collisions (mettre des rectangles statiques pour tester)
- [ ] Coder un ennemi générique, tester l'élimination par projectile, implémenter une IA
- [ ] Faire un niveau de test avec quelques ennemis

###### Phase 2 : *refactoring*

Structurer le code pour permettre de développer les éléments précédents : possibilité de créer de nouveaux ennemis, nouvelles armes, nouveaux niveaux... facilement.

###### Phase 3 : *level design*

Réfléchir à différents niveaux (schémas, concepts), créer des prototypes de ces niveaux qui implémentent des ennemis/des niveaux/des armes spécifiques.

###### Phase 4 : développement complet

###### Phase A (en continu) : tests *in situ*

Faire tester le jeu à des gens tout au long du processus de développement.
