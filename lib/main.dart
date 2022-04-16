import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'SavedSuggestion.dart';
import 'login.dart';
import 'login_screen.dart';
import 'package:hello_me/WordPairUtils.dart';




Future<void> main() async { // Future<void> main() async {
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
          return MaterialApp(
              home: Scaffold(
                  body: Center(
                      child: Text(snapshot.error.toString(),
                          textDirection: TextDirection.ltr)
                  )
              )
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => AuthRepository.instance()),
              ChangeNotifierProxyProvider<AuthRepository, RandomWordsNotifier>(
                create: (context) => RandomWordsNotifier(),
                update: (context, auth, notifier) => notifier!.update(auth),
              ),
            ],
            child: MyApp(),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator 2.0',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
      home: const RandomWords(),
    );
  }
}






class RandomWords extends StatelessWidget {
  const RandomWords({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthRepository,RandomWordsNotifier>(
      builder: (context, authRep, randomWords, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Startup Name Generator'),
            actions: [
              IconButton(
                icon: const Icon(Icons.star),
                onPressed: () {
                  _pushSaved(context);
                },
                tooltip: 'Saved Suggestions',
              ),
              IconButton(
                icon: authRep.isAuthenticated
                    ? const Icon(Icons.exit_to_app)
                    : const Icon(Icons.login),
                onPressed: () {
                  authRep.isAuthenticated
                      ? _pushLogout(context, authRep)
                      : _pushLogin(context);
                },
                tooltip: authRep.isAuthenticated ? 'Log out button' : 'Log in button',
              ),
            ],
          ),
          body: randomWords.buildSuggestions(),
        );
      },
    );
  }

  void _pushLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return UserLogin();
        },
      ),
    );
  }

  void _pushLogout(BuildContext context, AuthRepository authentication) async {
    await authentication.signOut();

  }

  void _pushSaved(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return  SavedSuggestion();
        },
      ),
    );
  }
}

















