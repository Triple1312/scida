

import '../../numpy/NDarray.dart';
import '../../pandas/dataframe/DDataFrame.dart';
import 'Vectorizer.dart';

class DictVectorizer extends Vectorizer{
  List<String> _vocab = [];

  DictVectorizer.transform(dynamic data) {
    if (data is DataFrame) { // todo maybe try to fix type mismatch
      dataFrameConstructor(data);
    }
  }

  @override
  void dataFrameConstructor(DataFrame data) {
    if (data.valueType != String) {
      throw Exception("DictVectorizer with type $String cannot be constructed with DataFrame of type ${data.valueType}");
    }
    else if (!data.all_bool()) {
      throw Exception("Tried to construct DictVectorizer with a DataFrame that contains null values");
    }
  }

  Map<String, int> translate_back(List<int> nda) {
    Map<String, int> ret ={};
    for (int i = 0; i < nda.length; i++) {
      if (nda[i] > 0) {
        ret[_vocab[i]] = nda[i];
      }
    }
    return ret;
  }

  void _transform(List<String> data) {
    for (int i = 0; i < data.length; i++) {
      if (!_vocab.contains(data[i])) {
        _vocab.add(data[i]);
      }
    }
  }

  @override
  NDarray<int> fit_transform(NDarray<Map<String,int>> data) {
    _transform(data.flat.keys.toList());
    return fit(data);
  }

  @override
  NDarray<int> fit(NDarray<Map<String, int>> data) {
    var elems = data.flat;

  }

  @override
  void transform(data) {
    // TODO: implement transform
  }



}