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
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Chaque widget définit une méthode build() automatiquement appelée dès que les conditions du widget changent, 
    //de sorte qu'il soit toujours à jour.

    var appState = context.watch<MyAppState>();
    //MyHomePage suit les modifications de l'état actuel de l'application avec la méthode watch.
    var pair = appState.current; 

    return Scaffold(
      //Chaque méthode build doit renvoyer un widget ou (plus généralement) une arborescence de widgets imbriquée. 
      //Dans ce cas, le widget de premier niveau est Scaffold
      body: Column(
        //Column est l'un des principaux widgets de mise en page de Flutter. 
        //Il accepte un nombre illimité d'enfants et les place dans une colonne, de haut en bas. 
        //Par défaut, la colonne place visuellement ses enfants en haut.
        children: [
          Text('A random idea:'),
          BigCard(pair: pair),
          //Ce second widget Text accepte appState et accède au seul membre de la classe, current (qui est une WordPair). 
          //WordPair fournit plusieurs getters utiles, comme asPascalCase ou asSnakeCase. 
          //Dans notre cas, nous utilisons asLowerCase
          ElevatedButton(
            onPressed: () {
                appState.getNext(); //appelle de fonction     
                },
            child: Text('Next'),
          ),
        ],
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

    return Card(
      color: theme.colorScheme.primary,
      //le code définit la couleur de la carte de sorte qu'elle soit identique à la propriété colorScheme du thème. 
      //Le jeu de couleurs comporte de nombreuses couleurs, primary étant la couleur prédominante qui définit l'application.
      child: Padding(
        //Refactor dans le widget Text. Wrap with Padding (Encapsuler avec une marge intérieure). 
        //Cela crée un widget parent appelé Padding autour du widget Text. 
        //Après avoir enregistré, notez que le mot aléatoire dispose plus d'espace.
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asLowerCase),
      ),
    );
  }
}