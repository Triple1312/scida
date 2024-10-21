

import 'dart:collection';

import '../document/Document.dart';

class InvertedIndices {

  HashMap<String, List<int>> invertedIndex = HashMap<String, List<int>>();

  List<Document> docs = [];

  List<String> voc = [];

  void fit(List<Document> documents) {
    for (int i = 0; i < documents.length; i++) {
      docs.add(documents[i]);
      List<String> terms = documents[i].contents.split(" ");
      for (String term in terms) {
        if (voc.contains(term)) {
          voc.add(term);
          invertedIndex[term] = [i];
        }
        else {
          invertedIndex[term]!.add(i);
        }
      }
    }
  }

  List<Document> query(String query) =>
    query_list(query.split(" "));

  List<Document> query_list(List<String> query) {
    List<int> doc_indeces = List<int>.generate(docs.length, (i) => i);
    for (String term in query) {
      List<int> new_indeces = [];
      if (voc.contains(term)) {
        for (int i in invertedIndex[term]!) {
          if (doc_indeces.contains(i)) {
            new_indeces.add(i);
          }
        }
        doc_indeces = new_indeces;
        if (doc_indeces.isEmpty) {
          return [];
        }
      }
      else {
        return [];
      }
    }
    return doc_indeces.map((i) => docs[i]).toList();
  }

}