import 'NData.dart';

/// This is made for specific 2D data to get an advantage for algorithms



class Sparce2D<T extends num> extends NData<T> {
  @override
  late List<int> shape;

  List<T> get values  {
    List<T> ret = List.filled( shape[0] * shape[1], 0 as T);
    for (int i = 0; i < _realvalues.length; i++) {
      for (int j = 0; j < _realvalues[i].length; j++) {
        ret[i * shape[1] + _realvalues[i][j].$1] = _realvalues[i][j].$2;
      }
    }
    return ret;
  }

  List<List<(int, T)>> _realvalues = [];

  @override
  operator [](int index) {
    // TODO: implement []
    throw UnimplementedError();
  }

  @override
  void operator []=(int index, T value) {
    // TODO: implement []=
  }

  @override
  void add(T value) {
    throw("dont use add on a sparce list");
  }

  @override
  // TODO: implement copy
  get copy => throw UnimplementedError();

  @override
  void fill(T value) {
    // TODO: implement fill
  }

  @override
  void fillRange(int start, int end, T value) {
    // TODO: implement fillRange
  }

  @override
  void fillna(T value) {
    // TODO: implement fillna
  }

  @override
  // TODO: implement flat
  List<T> get flat => throw UnimplementedError();

  @override
  List<T> flatten({String order = "C"}) {
    // TODO: implement flatten
    throw UnimplementedError();
  }

  int _translate_index(List<int> indeces) {
    for (int j = 0; j < _realvalues[indeces[0]].length; j++) {
      if (_realvalues[indeces[0]][j].$1 == indeces[1]) {
        return j;
      }
      else if (_realvalues[indeces[0]][j].$1 > indeces[1]) {
        return 0;
      }
    }
    return 0;
  }

  @override
  T get(List<int> loc) {
    if (loc.length != 2) {
      throw Exception('Number of indeces must match number of dimensions');
    }
    return values[_translate_index(loc)];
  }

  @override
  void insert(int index, T value) {
    // TODO: implement insert
  }

  @override
  void reshape(List<int> dimensions) {
    // TODO: implement reshape
  }

  @override
  void set(List<int> loc, T value) {
    // TODO: implement set
  }

  @override
  set values(List<T> values) {
    // TODO: implement values
  }


}