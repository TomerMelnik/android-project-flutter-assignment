import 'package:english_words/english_words.dart';

extension WordPairExt on WordPair{

  Map toJson() => {
    "first": first,
    "second": second,
  };

  WordPair fromJson(Map json) {
   return WordPair(json['first'], json['second']);
  }


}