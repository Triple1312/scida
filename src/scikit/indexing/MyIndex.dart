

import '../document/Document.dart';

class MyIndex {
  // Map<word, (docId, frequency)>
  Map<String, List<(int, int)>> words = {};
  List<String> docnames = [];


  Future<void> addToTerm(Stream<(String, (int, int))> stream) async {
    await for (var value in stream) {
      if (!words.containsKey(terms[j])) {
        words[value.$1]!.add((docnames.length - 1, tf[j]));
      }
      else {
        words[terms[j]] = [(docnames.length - 1,  tf[j])];
      }
    }
  }



  MyIndex.folder(String path) {

  }


  void addDocument(Document doc) {
    List<String> eek = doc.contents.split(" ");
    docnames.add(doc.filename);
    List<String> terms = [];
    List<int> tf = [];
    for (String term in eek) {
      bool found = false;
      for (int i = 0; i < terms.length; i++) {
        if (terms[i] == term) {
          tf[i]++;
          found = true;
          break;
        }
      }
      if (!found) {
        terms.add(term);
        tf.add(1);
      }
    }

    // add to index
    for (int j = 0; j < terms.length; j++) {
      if (!words.containsKey(terms[j])) {
        words[terms[j]]!.add((docnames.length - 1, tf[j]));
      }
      else {
        words[terms[j]] = [(docnames.length - 1,  tf[j])];
      }
    }

  }










}