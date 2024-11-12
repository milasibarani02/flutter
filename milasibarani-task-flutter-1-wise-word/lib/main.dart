import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Wise Word App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 184, 212)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var history = <WordPair>[];

  void getNext() {
    history.insert(0, current);
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2:
        page = HistoryPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        selectedIndex: selectedIndex,
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.favorite),
            icon: Icon(Icons.favorite_outline),
            label: "Favorite",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.history),
            icon: Icon(Icons.history_outlined),
            label: "History",
          ),
        ],
      ),
      body: page,
    );
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'You have ${appState.favorites.length} favorite words!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: const Color.fromARGB(255, 184, 95, 164).withOpacity(0.5),
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                    letterSpacing: 1.2,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          ...appState.favorites.map(
            (str) => ListTile(
              title: Text(str.asLowerCase),
              textColor: Theme.of(context).primaryColor,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("It's ${str.asLowerCase}!"),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              onLongPress: () {
                appState.favorites.remove(str);
                appState.notifyListeners();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${str.asLowerCase} removed from favorites!"),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Generated words history:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: const Color.fromARGB(255, 184, 95, 164).withOpacity(0.5),
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                    letterSpacing: 1.2,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              appState.history.clear();
              appState.notifyListeners();
            },
            child: Text('Clear History'),
          ),
          Expanded(
            child: ListView(
              children: appState.history.map(
                (str) => ListTile(
                  title: Text(str.asLowerCase),
                  textColor: Theme.of(context).primaryColor,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${str.asLowerCase}!"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
