

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
  documents.addModifier(new PorterStemmer());
  await documents.loadAllFiles(); // I need to rewrite to make this efficient
  print("all files loaded");
  Countvectorizer vectorizer = Countvectorizer();
  Matrix<num> matrix = vectorizer.fit_transform_corpus(documents);
  print("matrix created");






}