import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'WordPairUtils.dart';

class SavedSuggestion extends StatelessWidget {
  const SavedSuggestion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final saved = Provider.of<RandomWordsNotifier>(context, listen: false).saved;
    final tiles = saved.map<Widget>(
          (pair) {
        return Dismissible(
          child: ListTile(
            title: Text(
              pair.asPascalCase,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          key: ValueKey<WordPair>(pair),
          background: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.deepPurple,
            alignment: Alignment.centerLeft,
            child: Row(
              children: const [
                Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                Text(
                  "Delete suggestion",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          secondaryBackground: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.deepPurple,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  "Delete suggestion",
                  style: TextStyle(color: Colors.white),
                ),
                Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          confirmDismiss: (DismissDirection direction) async {
            return showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Delete Suggestion'),
                  content:  SingleChildScrollView(
                    child: Text('Are you sure you want to delete $pair from your saved suggestion?'),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        Provider.of<RandomWordsNotifier>(context, listen: false).removePair(pair);
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              },
            );
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
      ),
      body: ListView(children: divided),
    );
  }
}
