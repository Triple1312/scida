


import 'dart:math';

import 'package:meta/meta.dart';
import 'package:collection/collection.dart';

abstract class NData<T> extends Iterable<T>{

  ///Returns the value at location [loc]
  ///
  /// Parameters:
  /// - [loc] : List of indeces for every dimension
  /// - Returns: Value at location [loc]
  T get(List<int> loc);

  ///Sets the value at location [loc] to [value]
  ///
  /// Parameters:
  /// - [loc] : List of indeces for every dimension
  /// - [value] : Value to set at location [loc]
  void set(List<int> loc, T value);

  /// Returns the length of every dimension
  List<int> get shape;

  /// Returns the number of dimensions
  int get depth => shape.length;

  /// Returns the values as a flat list
  List<T> get flat;

  /// Returns the number of elements in the data
  int get size => shape.fold(1, (a, b) => a * b);

  /// Returns a copy of the data
  get copy;

  /// Returns the value at location [index]
  /// Parameters:
  /// - [index] : Index of the value
  operator[](int index);

  /// Sets the value at location [index] to [value]
  /// Parameters:
  /// - [index] : Index of the value
  /// - [value] : Value to set at location [index]
  operator[]=(int index, T value);

  /// changes the length of every dimension of the data to [dimensions]
  /// Parameters:
  /// - [dimensions] : List of the new length of every dimension
  void reshape(List<int> dimensions);

  /// Changes all values in the data to [value]
  /// Parameters:
  /// - [value] : Value to fill the data with
  void fill(T value);

  /// Changes all null values in the data to [value]
  /// Parameters:
  /// - [value] : Value to fill the null values with
  void fillna(T value);

  /// Changes all values in the data to [value] between [start] and [end]
  /// Parameters:
  /// - [start] : Start index
  /// - [end] : End index
  /// - [value] : Value to fill the data with
  void fillRange(int start, int end, T value);

  // void fillnaMean();

  // void fillnaMedian();

  /// Returns the data as a flat list in order [order]
  /// Parameters:
  /// - [order] : Order of the flat list, either "C" or "F" (default "C") with "C" being row-major and "F" being column-major (Fortran)
  List<T> flatten({String order="C"});

  /// Returns if the data contains any null values
  /// Returns: true if the data contains null values, false otherwise
  bool hasNull() { // todo make more efficient
    for (int i = 0; i < flat.length; i++) {
      if (flat[i] == null) {
        return true;
      }
    }
    return false;
  }

 // todo add documentation
  @protected
  void set values(List<T> values);

  @protected
  void set shape(List<int> shape);

  @protected
  NData();

  @override
  Iterator<T> get iterator => flat.iterator; // was NDataIt<T>

  NData.zeros(List<int> shape);
  
  List<T> diagonal() {
    int mindim = shape.reduce((current, next) => current < next ? current : next);
    List<T> diag = [];
    for (int i = 0; i < mindim; i++) {
      diag.add(get([i, i]));
    }
    return diag;
  }

  void insert(int index, T value);

  void add(T value);



}


class NList<T> extends DelegatingList<T> implements NData<T> {

  List<T> values;

  List<int> shape;


  NList(this.values, this.shape) : super(values);

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

  @override
  // TODO: implement depth
  int get depth => throw UnimplementedError();

  @override
  List<T> diagonal() {
    // TODO: implement diagonal
    throw UnimplementedError();
  }

  @override
  bool hasNull() {
    // TODO: implement hasNull
    throw UnimplementedError();
  }

  @override
  // TODO: implement size
  int get size => throw UnimplementedError();

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

// class NDataIt<T> implements Iterator<T> {
//   List<T> data;
//   int index = -1;
//
//   NDataIt(this.data);
//
//   @override
//   T get current => data[index];
//
//   @override
//   bool moveNext() {
//     index++;
//     return index < data.length;
//   }
//
// }