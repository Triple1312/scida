
import '../../pandas/dataframe/DDataFrame.dart';
import 'package:meta/meta.dart';
import 'dart:collection';

abstract class Vectorizer {
  @protected
  List<String> vocab = [];



  // @protected
  // void dataFrameConstructor(DataFrame data); // todo maybe could implement here // no idea what I should do with it

  bool contains(String key) => vocab.contains(key);

  String? translate(int index) => vocab[index];

  List<List<double>> fit_transform(List<String> documents, {bool sorted = false});

  void fit(List<String> documents, {bool sorted = false});

  List<List<double>> transform(List<String> documents);

  void fit_df(DataFrame data, String columnName) => fit(data.getColumn(columnName)!.asString());

  void fit_column(DFColumn data) => fit(data.asString());

  List<List<double>> transform_df(DataFrame data, String columnName) => transform(data.getColumn(columnName)!.asString());

  List<List<double>> transform_column(DFColumn data) => transform(data.asString());

  @protected
  void add_to_vocab(String word) {
    if (!vocab.contains(word)) {
      vocab.add(word);
    }
  }

}