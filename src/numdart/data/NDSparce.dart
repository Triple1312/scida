


import 'NData.dart';

import 'SortedList.dart';

class SparceBinMatrix extends NData<bool> {

  @override
  late List<int> shape;

  List<Sortedlist<int>> _values = new List.empty(growable: true);
  
  // List<int> get values { // I could try to use bits as bools
  //
  // }

  SparceBinMatrix(List<int> shape) {
    this.shape = shape;
    for (int i = 0; i < shape[0]; i++) {
      _values.add(Sortedlist<int>());
    }
  }

  SparceBinMatrix.data(List<List<int>> list) {
    shape = [list.length, list[0].length];
    for (int i = 0; i < shape[0]; i++) {
      _values.add(Sortedlist<int>());
      for (int j = 0; j < shape[1]; j++) {
        if (list[i][j] == 1) {
          _values[i].add(j);
        }
      }
    }
  }

  @override
  operator [](int index) { // todo no idea what I am going to do
    return _values[index~/shape[1]].contains(index%shape[1]);
  }

  @override
  void operator []=(int index, bool value) {
    if (value) {
      if (!_values[index~/shape[1]].contains(index%shape[1])) {
        _values[index~/shape[1]].add(index%shape[1]);
      }
    }
    else {
      _values[index~/shape[1]].remove(index%shape[1]);
    }
  }

  @override
  void add(bool value) {
    throw UnimplementedError();
  }

  @override
  // TODO: implement copy
  get copy => new SparceBinMatrix.data(_values);

  @override
  void fill(bool value) {
    // TODO: implement fill
  }

  @override
  void fillRange(int start, int end, bool value) {
    // TODO: implement fillRange
  }

  @override
  void fillna(bool value) {
    // TODO: implement fillna
  }

  @override
  List<bool> get flat =>  _values.fold(<bool>[], (a, b) => a+= (new List<int>.generate(shape[1], (i) => i)).fold(<bool>[], (c, d) => <bool>[c..., (b.contains(d)? true: false)]));

  @override
  List<bool> flatten({String order = "C"}) {
    if(order == "C") {
      return flat;
    }
    else if (order == "F") { // todo not tested // could be shorter/ more efficient
      List<bool> ret = [];
      for (int i = 0; i < shape[1]; i++) {
        for (int j = 0; j < shape[0]; j++) {
          if (_values[j].contains(i)) {
            ret.add(true);
          }
          else {
            ret.add(false);
          }
        }
      }
      return ret;
    }
    else {
      throw Exception("flatten order must be either 'C' or 'F'");
    }
  }

  @override
  bool get(List<int> loc) {
    if (loc.length != 2) throw Exception("loc must be of length 2");
    if (loc[0] >= shape[0] || loc[1] >= shape[1]) throw Exception("loc out of bounds");
    try {
      return _values[loc[0]].contains(loc[1]);
    }
    catch(e) {
      return false;
    }
  }

  @override
  void insert(int index, bool value) {
    set([index~/shape[0], index%shape[1]], value);
  }

  @override
  void reshape(List<int> dimensions) {
    // TODO: implement reshape
  }

  @override
  void set(List<int> loc, bool value) {
    if (loc.length != 2) throw Exception("loc must be of length 2");
    if (loc[0] >= shape[0] || loc[1] >= shape[1]) throw Exception("loc out of bounds");
    if (value) {
      if (!_values[loc[0]].contains(loc[1])) {
        _values[loc[0]].add(loc[1]);
      }
    }
    else {
      _values[loc[0]].remove(loc[1]);
    }
  }

  @override
  set values(List<bool> values) {
    // TODO: implement values
  }
  
  
  
  
  
  
}