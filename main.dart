

import 'dart:io';
import 'dart:isolate';

import 'src/numdart/new_data/Matrix.dart';
import 'src/pandas/new_dataframe/DFColumn.dart';
import 'src/pandas/new_dataframe/DataFrame.dart';
import 'src/scikit/document/Corpus.dart';
import 'src/scikit/feature_extraction/CountVectorizer.dart';
import 'src/scikit/feature_extraction/TfidfVectorizer.dart';
import 'src/scikit/indexing/QueryPerformanceAnalyser.dart';
import 'src/scikit/preprocessing/stemming/PorterStemmer.dart';


void checkpredictions() {
  DataFrame large_qres = DataFrame.from_csv("data/dev_query_results.csv", columnTypes:  [int, int]);
  DataFrame predictions = DataFrame.from_csv("tmp_scores.txt", seperator: "\t", columnTypes: [int, int, int, int, int, int, int, int, int, int, int]);

  DFColumn<int> doc_numbers = large_qres["doc_number"] as DFColumn<int>;
  DFColumn<int> query_numbers = large_qres["Query_number"] as DFColumn<int>;

  List<List<int>> relevant = [];
  List<List<int>> predicted = [];

  Map<int, List<int>> relevant_docs = {};
  for (int l = 0; l <  doc_numbers.length; l++) {
    int qn = query_numbers[l]!;
    if (!relevant_docs.containsKey(qn)) {
      relevant_docs[qn] = [];
    }
    relevant_docs[qn]!.add(doc_numbers[l]!);
  }


  for (int i = 0; i < predictions["queryId"].length; i++) {
    List<int> tmp_rel = [];
    List<int> tmp_pred = [predictions["doc1"][i], predictions["doc2"][i], predictions["doc3"][i], predictions["doc4"][i], predictions["doc5"][i], predictions["doc6"][i], predictions["doc7"][i], predictions["doc8"][i], predictions["doc9"][i], predictions["doc10"][i]];
    for (var tt in relevant_docs[predictions["queryId"][i]]!) {
      tmp_rel.add(tt);
    }
    relevant.add(tmp_rel);
    predicted.add(tmp_pred);
  }

  print("Map@3: ${QueryPerformanceAnalyser.mean_average_precision(relevant, predicted, 3)}");
  print("Map@10: ${QueryPerformanceAnalyser.mean_average_precision(relevant, predicted, 10)}");
  print("Mar@3: ${QueryPerformanceAnalyser.mean_average_recall(relevant, predicted, 3)}");
  print("Mar@10: ${QueryPerformanceAnalyser.mean_average_recall(relevant, predicted, 10)}");

}





void main() async{
  DataFrame large_queries = DataFrame.from_csv("data/dev_queries.tsv", seperator: "\t", columnTypes: [int, String]);
  DataFrame test_queries = DataFrame.from_csv("data/queries.csv", seperator: "\t", columnTypes: [int, String]);
  print("all dataframes loaded");
  Corpus documents = Corpus.folder("data\\full_docs");
  List<String> realDocNames = documents.docs.map((doc) => doc.filename.split("_").last.split('.').first).toList();
  documents.addModifier(new PorterStemmer(stopwords: true));
  PorterStemmer stemmer = new PorterStemmer(stopwords: true);
  print("all files loaded");

  await documents.loadAllFiles(); // I need to rewrite to make this efficient
  TfIdfVectorizer vectorizer = TfIdfVectorizer();
  vectorizer.fit_transform_corpus(documents);
  String filecontents = "Query_number,doc_number\n";
  for (int i = 0; i < test_queries["Query number"].length ; i++) {
    int queryId = test_queries["Query number"][i];
    String queryString = stemmer.stem_document(test_queries["Query"][i]);
    List<(int, num)> query = vectorizer.new_query(queryString, 10);
    // filecontents += "${queryId}";
    for (int j = 0; j < query.length; j++) {
      filecontents += "${queryId},${realDocNames[query[j].$1]}\n";
    }
    print("written query $queryId as row $i");
  }
  File file = new File("results.csv");
  // file.openWrite();
  file.openWrite();
  await file.writeAsString(filecontents);

  print("writen everything");

  checkpredictions();
}