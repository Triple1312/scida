

import 'dart:collection';

import '../../pandas/dataframe/DDataFrame.dart';
import 'Vectorizer.dart';

class Countvectorizer extends Vectorizer {


  @override
  List<List<double>> transform(List<String> documents) {
    // Precompute the indices in a map for quick lookup.
    Map<String, int> vocabIndices = {};
    for (int i = 0; i < vocab.length; i++) {
      vocabIndices[vocab[i]] = i;
    }

    return documents.map((document) {
      List<String> words = document.toLowerCase().split(" ");
      List<double> counts = List<double>.filled(vocab.length, 0.0);

      words.forEach((word) {
        if (vocabIndices.containsKey(word)) {
          counts[vocabIndices[word]!]++;
        }
      });

      return counts;
    }).toList();
  }

  @override
  void fit(List<String> documents, {bool sorted = false}) {
    for (String document in documents) {
      for (String word in document.toLowerCase().split(" ")) {
        if (!vocab.contains(word)) {
          vocab.add(word);
        }
      }
    }
    if (sorted) {
      vocab.sort();
    }
  }

  @override
  List<List<double>> fit_transform(List<String> documents, {bool sorted = false}) {
    fit(documents, sorted: sorted);
    return transform(documents);
  }

  List<List<int>> fit_transform_int(List<String> documents, {bool sorted = false}) {
    fit(documents, sorted: sorted);
    return transform_int(documents);
  }

  List<List<int>> transform_int(List<String> documents) {
    // Precompute the indices in a map for quick lookup.
    Map<String, int> vocabIndices = {};
    for (int i = 0; i < vocab.length; i++) {
      vocabIndices[vocab[i]] = i;
    }

    return documents.map((document) {
      List<String> words = document.toLowerCase().split(" ");
      List<int> counts = List<int>.filled(vocab.length, 0);

      words.forEach((word) {
        if (vocabIndices.containsKey(word)) {
          counts[vocabIndices[word]!]++;
        }
      });

      return counts;
    }).toList();
  }

}