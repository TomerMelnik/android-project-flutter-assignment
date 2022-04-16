import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login.dart';


class RandomWordsNotifier extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthRepository? _authRep;
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  get saved => _saved;

  void removePair(WordPair name) {
    _saved.remove(name);
    _updateFavourites(remove:name);
    notifyListeners();
  }

  Future getDocument(String? docID) async{
    var a = await _firestore.collection("users").doc(docID).get();
    if(a.exists){
      return a;
    }
    if(!a.exists){
      return null;
    }
  }

  void _getFavourites(AuthRepository authRepo) async {
    if (authRepo.isAuthenticated) {
      var cloudDoc = await getDocument(authRepo.user!.uid);
      if (cloudDoc == null) {
        _firestore.collection("users").doc(authRepo.user!.uid).set({"favourites": []});
      } else {
        var action =  _firestore.collection("users").doc(authRepo.user!.uid).get().then((value) {
          var wordsSet = {...List<String>.from(value.data()==null?{}:value.data()!["favourites"])};
          var parsedWords = wordsSet.map((e) => WordPair(e.split(RegExp(r"(?<=[a-z])(?=[A-Z])"))[0].toLowerCase(),e.split(RegExp(r"(?<=[a-z])(?=[A-Z])"))[1].toLowerCase()));
          _saved.addAll(parsedWords);
        }).then((value) {notifyListeners();});
      }
    }
  }

  void _updateFavourites({WordPair? remove = null}){
    if (_authRep == null) return;
    if (_authRep!.isAuthenticated) {
      if (remove == null) {
        var newList = _saved.map((e) => e.asPascalCase).toList();
        _firestore.collection("users").doc(_authRep!.user!.uid).update({"favourites":FieldValue.arrayUnion(newList)}).then((value) {});
        return;
        }
       _firestore.collection("users").doc(_authRep!.user!.uid).update({"favourites":FieldValue.arrayRemove([remove.asPascalCase])}).then((value) {});
      }
    }


  RandomWordsNotifier update(AuthRepository auth) {

    _getFavourites(auth);
    _authRep = auth;
    _updateFavourites();
    return this;
  }



  Widget buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return const Divider();
        }
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        var pair = _suggestions[index];

        final alreadySaved = _saved.contains(pair);
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: const TextStyle(fontSize: 18),
          ),
          trailing: Icon(
            alreadySaved ? Icons.star : Icons.star_border,
            color: alreadySaved ? Colors.deepPurple : null,
            semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
          ),
          onTap: () {
            if (alreadySaved) {
              _saved.remove(pair);
              _updateFavourites(remove:pair);
            } else {
              _saved.add(pair);
            _updateFavourites();
            }
            notifyListeners();
          },
        );
      },
    );
  }
}