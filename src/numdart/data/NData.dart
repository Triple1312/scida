


import 'dart:math';

import 'package:meta/meta.dart';

abstract class NData<T> extends Iterable<T>{

  T get(List<int> loc);

  void set(List<int> loc, T value);

  List<int> get shape;

  int get depth => shape.length;

  List<T> get flat;

  int get size => shape.fold(1, (a, b) => a * b);

  get copy;

  operator[](int index);

  operator[]=(int index, T value);

  void reshape(List<int> dimensions);

  void fill(T value);

  void fillna(T value);

  void fillRange(int start, int end, T value);

  // void fillnaMean();

  // void fillnaMedian();

  List<T> flatten({String order="C"});

  bool hasNull() { // todo make more efficient
    for (int i = 0; i < flat.length; i++) {
      if (flat[i] == null) {
        return true;
      }
    }
    return false;
  }

  @protected
  void set values(List<T> values);

  @protected
  void set shape(List<int> shape);

  @protected
  NData();

  @override
  NDataIt<T> get iterator => NDataIt(flat);

  NData.zeros(List<int> shape);
  
  List<T> diagonal() {
    int mindim = shape.reduce((current, next) => current < next ? current : next);
    List<T> diag = [];
    for (int i = 0; i < mindim; i++) {
      diag.add(get([i, i]));
    }
    return diag;
  }



}


class NList<T> extends NData<T> {

  List<T> values;

  List<int> shape;


  NList(this.values, this.shape);

  @override
  operator [](int index) {
    return values[index];
  }

  @override
  void operator []=(int index, T value) {
    values[index] = value;
  }

  int _translate_index(List<int> indeces) {
    int ind = 0;
    for (int i = 0; i < shape.length -1; i++) {
      ind += indeces[i] * shape[i];
    }
    ind += indeces.last;
    return ind;
  }

  @override
  T get(List<int> loc) {
    if (loc.length != shape.length) {
      throw Exception('Number of indeces must match number of dimensions');
    }
    return values[_translate_index(loc)];
  }

  @override
  NList<T> get copy => NList<T>(List<T>.generate(values.length, (i) => values[i]), shape);

  @override
  void fill(T value) {
    values = List.filled(size, value);
  }

  @override
  void fillRange(int start, int end, T value) {
    for (int i = start; i < end; i++) { // possibly more efficient
      values[i] = value;
    }
  }

  @override
  void fillna(T value) {
    for (int i = 0; i < values.length; i++) {
      if (values[i] == null) {
        values[i] = value;
      }
    }
  }

  List<T> _fFlat() => // todo werkt niet
  new List<int>.generate(shape.last,(i) => i+1)
      .map((i) => new List<int>.generate(values.length ~/ shape.last,(j) => j+1)
      .map((j) => values[j*shape.last + i]).toList()).toList().expand((i) => i).toList();

  @override
  List<T> get flat => values;

  @override
  List<T> flatten({String order = "C"}) {
    switch(order) {
      case 'C':
        return flat;
      case 'F':
        return _fFlat();
      default:
        throw Exception('order must be either "C" or "F" at the moment');
    }
  }

  @override
  void reshape(List<int> dimensions) {
    if (dimensions.fold(1, (a, b) => a * b) != size) {
      throw Exception('New shape must have same number of elements');
    }
    shape = dimensions;
  }

  @override
  void set(List<int> loc, T value) {
    if (loc.length != shape.length) {
      throw Exception('Number of indeces must match number of dimensions');
    }
    values[_translate_index(loc)] = value;
  }


}

class NumNList<T extends num> extends NList<T> {
  NumNList(List<T> values, shape): super(values, shape);


  void fillnaMean() {
    double mean = values.fold(0.0, ( num a, num b) => a + b) / values.length;
    fillna(mean as T);
  }

  void fillnaMedian() {
    num median = 0;
    if (size % 2 == 0) {
      median = (values[size ~/ 2] + values[size ~/ 2 + 1]) / 2;
    } else {
      median = values[size ~/ 2];
    }
    fillna(median as T);
  }
}

class NDataIt<T> implements Iterator<T> {
  List<T> data;
  int index = -1;

  NDataIt(this.data);

  @override
  T get current => data[index];

  @override
  bool moveNext() {
    index++;
    return index < data.length;
  }

}