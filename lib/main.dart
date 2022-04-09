import 'package:english_words/english_words.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './login.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());

}


class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Scaffold(
            body: Center(
                child: Text(snapshot.error.toString(),
                    textDirection: TextDirection.ltr)));
      }
      if (snapshot.connectionState == ConnectionState.done) {
        return  ChangeNotifierProvider(
          create:(context)=> AuthRepository.instance(),
          child:     MyApp(),);



      }
      return Center(child: CircularProgressIndicator());
        },
    );
  }
}

// #docregion MyApp
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // #docregion build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: const RandomWords(),
    );
  }
// #enddocregion build
}
// #enddocregion MyApp

// #docregion RWS-var
class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);

  // #enddocregion RWS-var

  // #docregion RWS-build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: _pushLogin,
            tooltip: 'login button',
          ),
        ],
      ),
      // #docregion itemBuilder
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          final alreadySaved = _saved.contains(_suggestions[index]);

          return ListTile(
            title: Text(
              _suggestions[index].asPascalCase,
              style: _biggerFont,
            ),
            trailing: Icon(
              alreadySaved ? Icons.star : Icons.star_border,
              color: alreadySaved ? Colors.deepPurple : null,
              semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
            ),
            onTap: () {
              setState(() {
                if (alreadySaved) {
                  _saved.remove(_suggestions[index]);
                } else {
                  _saved.add(_suggestions[index]);
                }
              });
            },
          );
        },
      ),
    );
  }

  void _pushLogin() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(children: [
              const Text(
                  "Welcome to Startup Names Generator, please log in below"),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                  width: double.infinity,


                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),)
                    ),
                      child: const Text('Log In'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login is not implemented yet")));
                      },
                    ),
                  ),
            ]),
          ));
    }));
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return Dismissible(
                child: ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                ),

                background: Container(
                  color: Colors.deepPurple,
                  child: Row(
                    children: const [
                      Icon(Icons.delete, color: Colors.white,),
                      Text("Delete Suggestion", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                key: ValueKey<int>(_saved.toList().indexOf(pair)),
                confirmDismiss: (DismissDirection direction) async {

                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Deletion is not implemented yet"))
                    );
                    return false;
                },
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}
