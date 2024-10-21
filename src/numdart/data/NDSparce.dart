
import 'NData.dart';

import 'SortedList.dart';

class SparceBinMatrix extends NData<int> {

  @override
  late List<int> shape;

  List<Sortedlist<int>> _values = new List.empty(growable: true);
  
  // List<int> get values { // I could try to use bits as bools
  //
  // }

  SparceBinMatrix(int x, int y) {
    this.shape = [x, y];
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
  void operator []=(int index, int value) {
    if (value != 0 && value != 1) throw Exception("value must be 0 or 1 in a binary matrix");
    if (value == 1) {
      if (!_values[index~/shape[1]].contains(index%shape[1])) {
        _values[index~/shape[1]].add(index%shape[1]);
      }
    }
    else {
      _values[index~/shape[1]].remove(index%shape[1]);
    }
  }

  @override
  void add(int value) {
    if (value != 0 && value != 1) throw Exception("value must be 0 or 1");
    throw UnimplementedError();
  }

  @override
  get copy => new SparceBinMatrix.data(_values);

  @override
  void fill(int value) {
    if (value != 0 && value != 1) throw Exception("value must be 0 or 1");
    // TODO: implement fill
  }

  @override
  void fillRange(int start, int end, int value) {
    if (value != 0 && value != 1) throw Exception("value must be 0 or 1");
    // TODO: implement fillRange
  }

  @override
  void fillna(int value) { // todo this matrix has no null values
    throw Exception("This matrix has no null values");

  }

  @override
  List<int> get flat =>  _values.fold(<int>[], (a, b) => a+= (new List<int>.generate(shape[1], (i) => i)).fold(<int>[], (c, d) => c+= [(b.contains(d)? 1: 0)]));

  @override
  List<int> flatten({String order = "C"}) {
    if(order == "C") {
      return flat;
    }
    else if (order == "F") { // todo not tested // could be shorter/ more efficient
      List<int> ret = [];
      for (int i = 0; i < shape[1]; i++) {
        for (int j = 0; j < shape[0]; j++) {
          if (_values[j].contains(i)) {
            ret.add(1);
          }
          else {
            ret.add(0);
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
  int get(List<int> loc) {
    if (loc.length != 2) throw Exception("loc must be of length 2");
    if (loc[0] >= shape[0] || loc[1] >= shape[1]) throw Exception("loc out of bounds");
    try {
      return _values[loc[0]].contains(loc[1]) ? 1 : 0;
    }
    catch(e) {
      return 0;
    }
  }

  @override
  void insert(int index, int value) {
    if (value != 0 && value != 1) throw Exception("value must be 0 or 1");
    set([index~/shape[0], index%shape[1]], value);
  }

  @override
  void reshape(List<int> dimensions) {
    // TODO: implement reshape
  }

  @override
  void set(List<int> loc, int value) {
    if (value != 0 && value != 1) throw Exception("value must be 0 or 1");
    if (loc.length != 2) throw Exception("loc must be of length 2");
    if (loc[0] >= shape[0] || loc[1] >= shape[1]) throw Exception("loc out of bounds");
    if (value == 1) {
      if (!_values[loc[0]].contains(loc[1])) {
        _values[loc[0]].add(loc[1]);
      }
    }
    else {
      _values[loc[0]].remove(loc[1]);
    }
  }

  @override
  set values(List<int> values) {
    if (values.length != shape[0]*shape[1]) throw Exception("values must have the same length as the matrix");
    _values = new List.generate(shape[0], (i) => Sortedlist<int>());
  }

  void addColumnInt(List<int> column) {

  }

  void addColumnBool(List<bool> column) {

  }

}