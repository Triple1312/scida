

import 'dart:io';
import 'dart:isolate';

import 'src/numdart/new_data/Matrix.dart';
import 'src/pandas/new_dataframe/DataFrame.dart';
import 'src/scikit/document/Corpus.dart';
import 'src/scikit/feature_extraction/CountVectorizer.dart';
import 'src/scikit/feature_extraction/TfidfVectorizer.dart';
import 'src/scikit/preprocessing/stemming/PorterStemmer.dart';

void main() async{
  DataFrame large_queries = DataFrame.from_csv("data/dev_queries.tsv", seperator: "\t", columnTypes: [int, String]);
  DataFrame large_qres = DataFrame.from_csv("data/dev_query_results.csv", columnTypes:  [int, int]);
  DataFrame test_queries = DataFrame.from_csv("data/queries.csv", seperator: "\t", columnTypes: [int, String]);
  print("all dataframes loaded");
  Corpus documents = Corpus.folder("data\\full_docs");
  List<String> realDocNames = documents.docs.map((doc) => doc.filename.split("_").last.split('.').first).toList();
  documents.addModifier(new PorterStemmer());
  PorterStemmer stemmer = new PorterStemmer();
  print("all files loaded");
  Corpus new_c = Corpus([]);
  new_c.modifiers = [stemmer];
  Set<int?> relevantDocs  = large_qres["doc_number"].toSet() as Set<int?>;
  for (var x in realDocNames) {
    if (relevantDocs.contains(int.parse(x))) {
      new_c.docs.add(documents.docs[realDocNames.indexOf(x)]);
    }
  }
  print(" all relevant docs loaded");



  await new_c.loadAllFiles(); // I need to rewrite to make this efficient
  TfIdfVectorizer vectorizer = TfIdfVectorizer();
  vectorizer.fit_corpus(new_c);
  String filecontents = "queryId\tdoc1\tdoc2\tdoc3\tdoc4\tdoc5\tdoc6\tdoc7\tdoc8\tdoc9\tdoc10\n";
  for (int i = 0; i < large_queries["Query number"].length ; i++) {
    int queryId = large_queries["Query number"][i];
    String queryString = stemmer.stem_document(large_queries["Query"][i]);
    List<(int, num)> query = vectorizer.query(queryString, 10);
    filecontents += "${queryId}";
    for (int j = 0; j < query.length; j++) {
      filecontents += "\t${realDocNames[query[j].$1]}";
    }
    filecontents += "\n";
    if (i % 10 == 0) print("written query $queryId");
  }
  File file = new File("tmp_scores.txt");
  // file.openWrite();
  file.openWrite();
  await file.writeAsString(filecontents);

  print("writen everything");

}