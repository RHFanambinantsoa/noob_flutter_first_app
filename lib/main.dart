import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
/** main() ici indique à Flutter d'exécuter l'application définie dans MyApp. */
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  /// La classe MyApp étend le StatelessWidget. 
  /// Les widgets sont les éléments que vous devez utiliser pour développer une application Flutter. 
  /// Notez que l'application elle-même est un widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // MyAppState détermine les données dont l'application a besoin pour fonctionner. 
  //  Pour le moment, elle ne comporte qu'une seule variable avec l'actuelle paire de mots aléatoires
  // La classe d'état étend ChangeNotifier qui peut alors informer les autres widgets de ses propres modifications.
  // L'état est créé et transmis à l'ensemble de l'application avec un ChangeNotifierProvider 
  //(voir le code ci-dessus dans MyApp). 
  //Cela permet de communiquer l'état à tous les widgets de l'application.
  var current = WordPair.random();

   void getNext() {
    //getNext() réattribue current à une nouvelle WordPair aléatoire. 
    //Elle appelle également notifyListeners() (une méthode de ChangeNotifier) qui garantit que toute personne surveillant MyAppState est informée.
    current = WordPair.random();
    notifyListeners();
  }

   var favorites = <WordPair>[];

  void toggleFavorite() { //Elle permet d'ajouter ou de supprimer l'actuelle paire de mots dans la liste des favoris (selon qu'elle s'y trouve ou non).
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}


class MyHomePage extends StatefulWidget { //StatefulWidget, un type de widget avec un State
//refactor sur myhomepage teo aloha izay statelesswidget -> convert to statefulwidget 
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> { //Cette classe étend State et peut donc gérer ses propres valeurs. (Elle peut changer d'elle-même.)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SafeArea( //SafeArea garantit que l'enfant n'est pas masqué par une encoche matérielle ni une barre d'état
            child: NavigationRail(
              extended: false, //Vous pouvez passer la ligne extended: false de NavigationRail sur true. Cela permet d'afficher les libellés en regard des icônes.
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
              ],
              selectedIndex: 0,
              onDestinationSelected: (value) { //définit ce qui se passe lorsque l'utilisateur sélectionne l'une des destinations (value == index)
                print('selected: $value');
              },
            ),
          ),
          Expanded(
            // Les widgets "Expanded" sont particulièrement utiles dans les lignes et les colonnes. 
            //Ils permettent d'exprimer la mise en page lorsque certains enfants n'utilisent que l'espace dont ils ont besoin (NavigationRail, dans ce cas) 
            //et que les autres widgets doivent occuper le plus d'espace restant possible (Expanded, dans ce cas)
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: GeneratorPage(),
            ),
          ),
        ],
      ),
    );
  }
}
class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Chaque widget définit une méthode build() automatiquement appelée dès que les conditions du widget changent, 
    //de sorte qu'il soit toujours à jour.

    var appState = context.watch<MyAppState>();
    //MyHomePage suit les modifications de l'état actuel de l'application avec la méthode watch.
    var pair = appState.current; 

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      //Chaque méthode build doit renvoyer un widget ou (plus généralement) une arborescence de widgets imbriquée. 
      //Dans ce cas, le widget de premier niveau est Scaffold
      body: Center(
        //refactor -> wrap with center
        child: Column(
          //Column est l'un des principaux widgets de mise en page de Flutter. 
          //Il accepte un nombre illimité d'enfants et les place dans une colonne, de haut en bas. 
          //Par défaut, la colonne place visuellement ses enfants en haut.
      
          mainAxisAlignment: MainAxisAlignment.center, //permet de centrer l'enfant dans la Column, le long de l'axe principal (verticalement).
      
          children: [
            BigCard(pair: pair),            
            SizedBox(height: 10,), //Le widget SizedBox prend de la place sans rien afficher directement. Il est communément utilisé pour créer des séparations visuelles.
            Row( //wrap with row
              mainAxisSize: MainAxisSize.min, //indique à la Row qu'elle ne doit pas occuper tout l'espace horizontal disponible.
              children: [
                ElevatedButton.icon( //créer un bouton avec une icône
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Like'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                      appState.getNext(); //appelle de fonction     
                      },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//refactor (ctrl + .) eo amin'ilay widget ohatra hoe Text izy teto -> Extract Widget (Extraire le widget)
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); //le code demande le thème actuel de l'application avec Theme.of(context)
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    //theme.textTheme, permet d'accéder au thème des polices. Cette classe comprend des membres comme bodyMedium (pour le texte standard de taille moyenne), caption (pour les captures d'images) ou headlineLarge (pour les gros titres).
    //La propriété displayMedium est un grand style prévu pour le titrage du texte. "les styles de titrage sont réservés aux textes courts et importants" 
    //En théorie, la propriété displayMedium du thème peut être null. Dart (le langage de programmation utilisé pour écrire cette application) est null-safe et ne permet donc pas d'appeler les méthodes d'objets potentiellement null. Dans ce cas, vous pouvez toutefois utiliser l'opérateur ! ("opérateur bang") pour indiquer à Dart que vous savez ce que vous faites
    //Appeler copyWith() sur displayMedium renvoie une copie du style de texte avec les modifications que vous avez apportées. Dans ce cas, vous n'avez fait que modifier la couleur du texte.
    //Pour obtenir la nouvelle couleur, accédez de nouveau au thème de l'application. La propriété onPrimary du jeu de couleurs définit une couleur adaptée pour apparaître au-dessus de la couleur principale de l'application.
    
    return Card(
      color: theme.colorScheme.primary,
      //le code définit la couleur de la carte de sorte qu'elle soit identique à la propriété colorScheme du thème. 
      //Le jeu de couleurs comporte de nombreuses couleurs, primary étant la couleur prédominante qui définit l'application.
      child: Padding(
        //Refactor dans le widget Text. Wrap with Padding (Encapsuler avec une marge intérieure). 
        //Cela crée un widget parent appelé Padding autour du widget Text. 
        //Après avoir enregistré, notez que le mot aléatoire dispose plus d'espace.
        padding: const EdgeInsets.all(20.0),
      child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
          //Maintenant, les lecteurs d'écrans prononcent correctement chaque paire de mots générée sans que l'UI ait changé.
        ),
      ),
    );
  }
}