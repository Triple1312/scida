

import 'dart:collection';

import 'package:meta/meta.dart';

import '../../numpy/old/OMatrix.dart';
import '../../pandas/dataframe/DataFrame.dart';

abstract class Encoder extends OMatrix<num> {

  @protected
  DataFrame df;

  @protected
  bool keep_numbers;

  @protected
  List<HashMap<int, dynamic>> mapping = [];

  Encoder({required DataFrame this.df, bool this.keep_numbers = true}): super.zeros(df.size) {

  }


}