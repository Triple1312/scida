

import 'dart:collection';

import '../../numdart/new_data/Matrix.dart';
import '../../numdart/new_data/Vector.dart';
import '../document/Corpus.dart';
import 'Vectorizer.dart';

class Countvectorizer extends Vectorizer {

  Matrix<num> data = Matrix<num>.empty();

  @override
  Matrix<num> transform(List<String> documents) {
    // // Precompute the indices in a map for quick lookup.
    // Map<String, int> vocabIndices = {};
    // for (int i = 0; i < vocab.length; i++) {
    //   vocabIndices[vocab[i]] = i;
    // }
    //
    // return documents.map((document) {
    //   List<String> words = document.toLowerCase().split(" ");
    //   List<double> counts = List<double>.filled(vocab.length, 0.0);
    //
    //   words.forEach((word) {
    //     if (vocabIndices.containsKey(word)) {
    //       counts[vocabIndices[word]!]++;
    //     }
    //   });
    //
    //   return counts;
    // }).toList();
    return new Matrix<num>.empty();
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
  Matrix<num> fit_transform(List<String> documents, {bool sorted = false}) {
    fit(documents, sorted: sorted);
    return transform(documents);
  }

  Matrix<num> fit_transform_corpus(Corpus corpus, {bool sorted = false}) {
    List<String> vocab = [];
    List<Vector<num>> docmatrix = [];

    for (int i = 0; i < corpus.length; i++) {
      Map<String, int> tmp_words = new Map(); // because words that are already found in a document have a higher chance of comming back
      for (String word in corpus[i].contents.toLowerCase().split(" ")) {
        tmp_words[word] = tmp_words.containsKey(word) ? tmp_words[word]! + 1 : 1; // dont know if fast enough
      }
      docmatrix.add(Vector.empty());
      tmp_words.forEach((key, value) {
        int index = vocab.indexOf(key);
        if (index == -1) {
          vocab.add(key);
          index = vocab.length - 1;
          docmatrix[i].addExtend(index, value);
        }
        else {
          docmatrix[i].addExtend(index, value);
        }
      });
      if(i % 1000 == 0) {
        print(i);
      }
    }
    this.data = Matrix<num>.csr(values: docmatrix);
    return data;
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