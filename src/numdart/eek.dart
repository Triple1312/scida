

import 'dart:math' as math;
import 'dart:math';

import 'package:meta/meta.dart';

abstract interface class N2Data<T> implements List<T>{

  void set(List<int> loc, T value);

  T get(List<int> loc);

  N2Data<T> copy();

  void fill(T value);

  void fillRange(int start, int end, [T? value]);

  void fillna(T value);

  List<T> flatten({String order = "C"});

  List<T> get flat => flatten();

  void reshape(List<int> dimensions);

  void insert(int index, T value);

  List<int> get shape;

  bool hasNull();

  int get depth => shape.length;

  int get size => shape.fold(1, (a, b) => a * b);

  String get type;

}


mixin N2DataLstMixin<T> implements N2Data<T> {

  @override
  T get first => flat.first;

  @override
  T get last => flat.last;

  @override
  int get length => flat.length;

  List<int> shape = [];

  @override
  List<T> operator +(List<T> other) => flat + other;

  @override
  T operator [](int index) => flat[index];

  @override
  void operator []=(int index, T value) => flat[index] = value;

  @override
  void add(T value) => flat.add(value); // todo is possible ?

  @override
  void addAll(Iterable<T> iterable) => flat.addAll(iterable); // todo is possible ?

  @override
  bool any(bool Function(T element) test) => flat.any(test);

  @override
  Map<int, T> asMap() => flat.asMap();

  @override
  List<R> cast<R>() => flat.cast<R>();

  @override
  void clear() => flat.clear();

  @override
  bool contains(Object? element) => flat.contains(element);

  @override
  T elementAt(int index) => flat.elementAt(index);

  @override
  bool every(bool Function(T element) test) => flat.every(test);

  @override
  Iterable<T> expand<T>(Iterable<T> Function(T element) toElements) {
    // TODO: implement expand
    throw UnimplementedError();
  }

  @override
  T firstWhere(bool Function(T element) test, {T Function()? orElse}) => flat.firstWhere(test, orElse: orElse);

  @override
  T fold<T>(T initialValue, T Function(T previousValue, T element) combine) => flat.fold<T>(initialValue, combine);

  @override
  Iterable<T> followedBy(Iterable<T> other) => flat.followedBy(other);

  @override
  void forEach(void Function(T element) action) => flat.forEach(action);

  @override
  Iterable<T> getRange(int start, int end) => flat.getRange(start, end);

  @override
  int indexOf(T element, [int start = 0]) => flat.indexOf(element, start);

  @override
  int indexWhere(bool Function(T element) test, [int start = 0]) => flat.indexWhere(test, start);

  @override
  void insertAll(int index, Iterable<T> iterable) => flat.insertAll(index, iterable);

  @override
  bool get isEmpty => flat.isEmpty;

  @override
  bool get isNotEmpty => flat.isNotEmpty;

  @override
  Iterator<T> get iterator => flat.iterator;

  @override
  String join([String separator = ""]) => flat.join(separator);

  @override
  int lastIndexOf(T element, [int? start]) => flat.lastIndexOf(element, start);

  @override
  int lastIndexWhere(bool Function(T element) test, [int? start]) => flat.lastIndexWhere(test, start);

  @override
  T lastWhere(bool Function(T element) test, {T Function()? orElse}) => flat.lastWhere(test, orElse: orElse);

  @override
  Iterable<T> map<T>(T Function(T e) toElement) => flat.map(toElement);

  @override
  T reduce(T Function(T value, T element) combine) => flat.reduce(combine);

  @override
  bool remove(Object? value) => flat.remove(value);

  @override
  T removeAt(int index) => flat.removeAt(index);

  @override
  T removeLast() => flat.removeLast();

  @override
  void removeRange(int start, int end) => flat.removeRange(start, end);

  @override
  void removeWhere(bool Function(T element) test) => flat.removeWhere(test);

  @override
  void replaceRange(int start, int end, Iterable<T> replacements) => flat.replaceRange(start, end, replacements);

  @override
  void retainWhere(bool Function(T element) test) => flat.retainWhere(test);

  @override
  Iterable<T> get reversed => flat.reversed;

  @override
  void setAll(int index, Iterable<T> iterable) => flat.setAll(index, iterable);

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) => flat.setRange(start, end, iterable, skipCount);

  @override
  void shuffle([Random? random]) => flat.shuffle(random);

  @override
  T get single => flat.single;

  @override
  T singleWhere(bool Function(T element) test, {T Function()? orElse}) => flat.singleWhere(test, orElse: orElse);

  @override
  Iterable<T> skip(int count) => flat.skip(count);

  @override
  Iterable<T> skipWhile(bool Function(T value) test) => flat.skipWhile(test);

  @override
  void sort([int Function(T a, T b)? compare]) => flat.sort(compare);

  @override
  List<T> sublist(int start, [int? end]) => flat.sublist(start, end);

  @override
  Iterable<T> take(int count) => flat.take(count);

  @override
  Iterable<T> takeWhile(bool Function(T value) test) => flat.takeWhile(test);

  @override
  List<T> toList({bool growable = true}) => flat.toList(growable: growable);

  @override
  Set<T> toSet() => flat.toSet();

  @override
  Iterable<T> where(bool Function(T element) test) => flat.where(test);

  @override
  Iterable<T> whereType<T>() => flat.whereType<T>();

  @override
  set first(T value) => flat.first = value;

  @override
  set last(T value) => flat.last = value;

  @override
  set length(int newLength) => flat.length = newLength;

}

class N2DList<T> with N2DataLstMixin<T>  {
  
  String get type => "List";

  @protected
  List<T> values;

  List<int> shape;

  N2DList(this.values, this.shape);

  @override
  N2Data<T> copy() {
    return N2DList(List<T>.from(values), List<int>.from(shape));
  }

  @override
  int get depth => shape.length;

  @override
  void fill(T value) {
    values = List<T>.filled(size, value);
  }

  @override
  void fillRange(int start, int end, T value) {
    values = values.fold([], (a,b) => a.length >= start && a.length < end ? a + [value] : a + [b]);
  }

  @override
  void fillna(T value) {
    for (int i = 0; i < values.length; i++) {
      if (values[i] == null) {
        values[i] = value;
      }
    }
  }

  @override
  List<T> get flat => values;

  @override
  List<T> flatten({String order = "C"}) {
    // TODO: implement flatten
    throw UnimplementedError();
  }

  @override
  T get(List<int> loc) {
    if (loc.length != shape.length) {
      throw Exception('Number of indeces must match number of dimensions');
    }
    return values[_translate_index(loc)];
  }

  @override
  bool hasNull() {
    if (values.any((element) => element == null)) {
      return true;
    }
    return false;
  }

  @override
  void insert(int index, T value) {
    if (depth != 1) {
      throw Exception('Can only insert in 1D list');
    }
    values.insert(index, value);
  }

  @override
  void reshape(List<int> dimensions) {
    if (dimensions.fold(1, (a, b) => a * b) != size) {
      throw Exception("Invalid dimensions");
    }
    shape = dimensions;
  }

  @override
  int get size => values.length;

  int _translate_index(List<int> indeces) {
    int ind = 0;
    for (int i = 0; i < shape.length -1; i++) {
      ind += indeces[i] * shape[i];
    }
    ind += indeces.last;
    return ind;
  }

  @override
  void set(List<int> loc, T value) {
    if (loc.length != shape.length) {
      throw Exception('Number of indeces must match number of dimensions');
    }
    values[_translate_index(loc)] = value;
  }

}

class N2DSparce<T> with N2DataLstMixin<T> {
  
  String get type => "Sparce";

  List<int> shape;

  @override
  N2Data<T> copy() {
    // TODO: implement copy
    throw UnimplementedError();
  }

  @override
  // TODO: implement depth
  int get depth => throw UnimplementedError();

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

  @override
  T get(List<int> loc) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  bool hasNull() {
    // TODO: implement hasNull
    throw UnimplementedError();
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
  // TODO: implement size
  int get size => throw UnimplementedError();
}

class N2SparceBinData<T> with N2DataLstMixin<T> {

  String get type => "Binary";

  List<int> shape;

  List<int> indeces; // should always be sorted // make binary tree or something better

  N2SparceBinData(this.indeces, this.shape){
    indeces.sort();
  }


  @override
  int get depth => shape.length;

  @override
  void fill(value) {
    if (value != 0 && value != 1) {
      throw Exception('Invalid value');
    }
    if (value == 0) {
      indeces = [];
    }
    else {
      indeces = List<int>.generate(shape.fold(1, (a, b) => a * b), (i) => i);
    }
  }

  @override
  void fillRange(int start, int end, value) {
    // TODO: implement fillRange
  }

  @override
  void fillna(value) { // is different for binary, since null is not an option
    if (value != 0 && value != 1) {
      throw Exception('Invalid value');
    }
    if (value == 0) {
      indeces = [];
    }
    else {
      indeces = List<int>.generate(shape.fold(1, (a, b) => a * b), (i) => i);
    }
  }

  @override
  List get flat {
    List<int> values;
    int count = 0;
    for (int i = 0; i < indeces.length; i++) {

    }
  }

  @override
  List flatten({String order = "C"}) {
    // TODO: implement flatten
    throw UnimplementedError();
  }

  @override
  get(List<int> loc) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  bool hasNull() {
    // TODO: implement hasNull
    throw UnimplementedError();
  }

  @override
  void insert(int index, value) {
    // TODO: implement insert
  }

  @override
  void reshape(List<int> dimensions) {
    // TODO: implement reshape
  }

  @override
  void set(List<int> loc, value) {
    // TODO: implement set
  }

  @override
  // TODO: implement size
  int get size => throw UnimplementedError();

  @override
  N2Data<T> copy() {
    // TODO: implement copy
    throw UnimplementedError();
  }
}

class N2D2SparceBinMatrix with N2DataLstMixin<int> {

  String get type => "BinaryMatrix";

  List<int> shape;

  List<int> indeces; // should always be sorted // make binary tree or something better

  N2D2SparceBinMatrix(this.indeces, this.shape) {
    indeces.sort();
  }

  @override
  N2Data<int> copy() {
    // TODO: implement copy
    throw UnimplementedError();
  }

  @override
  int get depth => 2; // always has to be 2

  @override
  void fill(int value) {
    if (value == 0) {
      indeces = [];
    }
    else if (value == 1) {
      print("wtf you doin");
      indeces = List<int>.generate(shape.fold(1, (a, b) => a * b), (i) => i);
    }
    else {
      throw Exception('Invalid value');
    }
  }

  @override
  void fillRange(int start, int end, [int? value]) {
    // TODO: implement fillRange
  }

  @override
  void fillna(int value) {
    // TODO: implement fillna
  }

  @override
  List<int> get flat {
    List<int> values = [];
    for (int i = 0; i < indeces.length; i++) {
      values += List<int>.generate(i - values.length -1, (i) => 0) + [1];
    }
    return values + List<int>.generate(size - values.length, (i) => 0);
  }

  @override
  List<int> flatten({String order = "C"}) {
    // TODO: implement flatten
    throw UnimplementedError();
  }

  @override
  int get(List<int> loc) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  bool hasNull() {
    // TODO: implement hasNull
    throw UnimplementedError();
  }

  @override
  void insert(int index, int value) {
    // TODO: implement insert
  }

  @override
  void reshape(List<int> dimensions) {
    // TODO: implement reshape
  }

  @override
  void set(List<int> loc, int value) {
    // TODO: implement set
  }

  @override
  int get size => shape.fold(1, (a, b) => a * b);
}



abstract interface class N2DMathArray<T extends num> extends N2Data<T> { // todo remove the mixin

  N2Data<T> get data;
  
  double norm(int value);
  
  double infinityNorm();

  N2DMathArray<T> dot(N2DMathArray<T> other);

  asNum();

  asInt();

  asDouble();
  
}

mixin N2DArrayMathMixin<T extends num> implements N2DMathArray<T> {

  N2Data<T> get data;

  List<T> get flat => data.flat;

  int get depth => data.depth;

  int get size => data.size;

  void fill(T value) => data.fill(value);

  void fillRange(int start, int end, [T? value]) => data.fillRange(start, end, value);

  void fillna(T value) => data.fillna(value);

  List<T> flatten({String order = "C"}) => data.flatten(order: order);

  T get(List<int> loc) => data.get(loc);

  void insert(int index, T value) => data.insert(index, value);

  void reshape(List<int> dimensions) => data.reshape(dimensions);

  void set(List<int> loc, T value) => data.set(loc, value);

  bool hasNull() => data.hasNull();

  T get mean => (data.reduce((a, b) => (a + b) as T) / data.size) as T;

  T get sum => data.reduce((a, b) => (a + b) as T);

  T get max => data.reduce((a, b) => a > b ? a : b);

  T get min => data.reduce((a, b) => a < b ? a : b);
  
  T get first => data.first;
  
  T get last => data.last;
  
  int get length => data.length;
  
  List<int> get shape => data.shape;
  
  T operator [](int index) => data[index];
  
  void operator []=(int index, T value) => data[index] = value;
  
  void add(T value) => data.add(value);
  
  void addAll(Iterable<T> iterable) => data.addAll(iterable);
  
  bool any(bool Function(T element) test) => data.any(test);
  
  Map<int, T> asMap() => data.asMap();

  
  List<R> cast<R>() => data.cast<R>();

  
  void clear() => data.clear();

  
  bool contains(Object? element) => data.contains(element);

  
  T elementAt(int index) => data.elementAt(index);

  
  bool every(bool Function(T element) test) => data.every(test);

  
  Iterable<R> expand<R>(Iterable<R> Function(T element) toElements) => data.expand(toElements);

  
  T firstWhere(bool Function(T element) test, {T Function()? orElse}) => data.firstWhere(test, orElse: orElse);

  
  R fold<R>(R initialValue, R Function(R previousValue, T element) combine) => data.fold<R>(initialValue, combine);

  
  Iterable<T> followedBy(Iterable<T> other) => data.followedBy(other);

  
  void forEach(void Function(T element) action) => data.forEach(action);

  
  Iterable<T> getRange(int start, int end) => data.getRange(start, end);

  
  int indexOf(T element, [int start = 0]) => data.indexOf(element, start);

  
  int indexWhere(bool Function(T element) test, [int start = 0]) => data.indexWhere(test, start);

  
  void insertAll(int index, Iterable<T> iterable) => data.insertAll(index, iterable);

  
  bool get isEmpty => data.isEmpty;

  
  bool get isNotEmpty => data.isNotEmpty;

  
  Iterator<T> get iterator => data.iterator;

  
  String join([String separator = ""]) => data.join(separator);

  
  int lastIndexOf(T element, [int? start]) => data.lastIndexOf(element, start);

  
  int lastIndexWhere(bool Function(T element) test, [int? start]) => data.lastIndexWhere(test, start);

  
  T lastWhere(bool Function(T element) test, {T Function()? orElse}) => data.lastWhere(test, orElse: orElse);

  
  Iterable<R> map<R>(R Function(T e) toElement) => data.map(toElement);

  
  T reduce(T Function(T value, T element) combine) => data.reduce(combine);

  
  bool remove(Object? value) => data.remove(value);

  
  T removeAt(int index) => data.removeAt(index);

  
  T removeLast() => data.removeLast();

  
  void removeRange(int start, int end) => data.removeRange(start, end);

  
  void removeWhere(bool Function(T element) test) => data.removeWhere(test);

  
  void replaceRange(int start, int end, Iterable<T> replacements) => data.replaceRange(start, end, replacements);

  
  void retainWhere(bool Function(T element) test) => data.retainWhere(test);

  
  Iterable<T> get reversed => data.reversed;

  
  void setAll(int index, Iterable<T> iterable) => data.setAll(index, iterable);

  
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) => data.setRange(start, end, iterable, skipCount);

  
  void shuffle([Random? random]) => data.shuffle(random);

  
  T get single => data.single;

  
  T singleWhere(bool Function(T element) test, {T Function()? orElse}) => data.singleWhere(test, orElse: orElse);

  
  Iterable<T> skip(int count) => data.skip(count);

  
  Iterable<T> skipWhile(bool Function(T value) test) => data.skipWhile(test);

  
  void sort([int Function(T a, T b)? compare]) => data.sort(compare);

  
  List<T> sublist(int start, [int? end]) => data.sublist(start, end);

  
  Iterable<T> take(int count) => data.take(count);

  
  Iterable<T> takeWhile(bool Function(T value) test) => data.takeWhile(test);

  
  List<T> toList({bool growable = true}) => data.toList(growable: growable);

  
  Set<T> toSet() => data.toSet();

  
  Iterable<T> where(bool Function(T element) test) => data.where(test);

  
  Iterable<T> whereType<T>() => data.whereType<T>();

  
  set first(value) => data.first = value;

  
  set last(value) => data.last = value;

  
  set length(int newLength) => data.length = newLength; // todo shouldnt work ???

  List<T> operator +(List<T> other) {
    if (other is N2Data) {
      return flat + (other);
    }
    else {
      throw Exception('Can only add N2Data');
    }
  }

  int asInt() {
    if (data.length != 1) {
      throw Exception('Can only convert 1D array to int');
    }
    return data[0] as int;
  }

  double asDouble() {
    if (data.length != 1) {
      throw Exception('Can only convert 1D array to double');
    }
    return data[0] as double;
  }

  num asNum() {
    if (data.length != 1) {
      throw Exception('Can only convert 1D array to num');
    }
    return data[0];
  }

}


class N2Vector<T extends num> with N2DArrayMathMixin<T> {

  N2Data<T> data;

  N2Vector(this.data);

  N2Vector.fromList(List<T> values) : data = N2DList(values, [values.length]);

  N2Vector.fromRange(int start, int end, [int step = 1]) : data = N2DList( // todo idk what this does
      List<T>.generate((end - start) ~/ step, (index) => (start + index * step) as T),
      [(end - start) ~/ step]);

  N2Vector.zeroes(int shape) : data = N2DList(List<T>.filled(shape, 0 as T), [shape]);



  @override
  double norm(int value) {
         throw UnimplementedError();
  }

  @override
  double infinityNorm() {
     throw  UnimplementedError();
  }

  bool operator ==(Object other) {
    if (other is List<T>) {
      for (int i = 0; i < data.length; i++) {
        if (data[i] != other[i]) {
          return false;
        }
      }
      return true;
    }
    else {
      return false;
    }
  }

  @override
  N2Vector<T> copy() {
    return N2Vector(data.copy());
  }

  @override
  String get type => "Vector";

  N2Vector<T> operator *(num other) { // could also return non T, but chose this
    return N2Vector(N2DList(data.fold([], (a, b) => a + [b * other as T]), [data.length]));
  }

  N2Vector operator /(num other) {
    return N2Vector(N2DList(data.fold([], (a, b) => a + [b / other as T]), [data.length]));
  }

  num dotV(List<num> v) {
    if (data.length != v.length) {
      throw Exception('Vectors must be same size');
    }
    return List.generate(data.length, (i) => data[i] * v[i]).fold(0, (a, b) => a + b);
  }

  num get product => data.reduce((a, b) => (a * b) as T);

  // N2Vector dotM(N2Matrix m) {}


  N2Vector proj(N2Vector v) {
    return v * (v.dotV(this) / v.dotV(v));
  }

  N2Vector operator-(N2Vector other) {
    List<num> vals = [];
    for (int i = 0; i < data.length; i++) {
      vals.add(data[i] - other.data[i]);
    }
    return N2Vector.fromList(vals);
  }

  @override
  N2DMathArray<T> dot(N2DMathArray<T> other) {
    // TODO: implement dot
    throw UnimplementedError();
  }



}

class N2Matrix<T extends num> with N2DArrayMathMixin<T> {

  N2Data<T> data;
  
  ///////////////////// Constructors /////////////////////

  N2Matrix(this.data);

  N2Matrix.fromList(List<T> values, List<int> shape) : data = N2DList(values, shape);

  // N2Matrix.rowsInit(List<List<T>> values) : data = N2DList(values.fold([], (a,b) => a + b), [values.length, values[0].length]) {
  //   int length = values[0].length; // also catches empty list which I think should be invalid
  //   for (int i = 1; i < values.length; i++) {
  //     if (values[i].length != length) {
  //       throw Exception('All rows must have the same length');
  //     }
  //   }
  // }

  N2Matrix.zeroes(List<int> shape) :
        data = N2DList(List<T>.filled(shape.fold(1, (a, b) => a * b), 0 as T), shape);

  N2Matrix.identity(int size) :
        data = N2DList(List.generate(size * size, (i) => i % (size + 1) == 0 ? 1 as T : 0 as T), [size, size]);

  N2Matrix.rowsInit(List<N2Vector<T>> basis) :
        data = N2DList(basis.fold(List<T>.empty(), (List<T> a, N2Vector<T> b) => a + b), [basis[0].size, basis.length]); // todo should call basis ??? // add length constraint

  N2Matrix.columnsInit(List<N2Vector<T>> basis) :
        data = N2DList(_colInitHelper<T>(basis), [basis[0].size, basis.length]);

  static List<T> _colInitHelper<T extends num>(List<N2Vector<T>> basis) { // todo maybe optimize
    List<T> vals = [];
    for (int i = 0; i < basis.length; i++) {
      for (int j = 0; j < basis[0].size; j++) {
        vals.add(basis[j][i]);
      }
    }
    return vals;
  }
  

  @override
  double infinityNorm() {
    // TODO: implement infinityNorm
    throw UnimplementedError();
  }

  @override
  double norm(int value) {
    // TODO: implement norm
    throw UnimplementedError();
  }

  @override
  N2Matrix<T> copy() => N2Matrix(data.copy());

  @override
  String get type => "Matrix";


  int get rowLength => shape[0];

  int get columnLength => shape[1];

  int get rowCount => shape[1];

  int get columnCount => shape[0];

  N2Matrix dotM(N2Matrix m) {
    N2Matrix met = this.copy();
    for (int i = 0; i < shape[0]; i++) {
      for (int j = 0; j < shape[1]; j++) {
        num sum = 0;
        for (int k = 0; k < shape[1]; k++) {
          sum += data.get([i,k]) * m.get([k,j]);
        }
        met.set([i, j], sum);
      }
    }
    return met;
  }

  N2Vector<T> get diagonal {
    if (shape[0] != shape[1]) {
      throw Exception('Matrix must be square');
    }
    int m = math.min(shape[0], shape[1]);
    return N2Vector(N2DList(List<T>.generate(m, (i) => data.get([i,i])), [m]));
  }

  num get diagonalSum => diagonal.sum;

  num get trace => diagonalSum;

  num get diagonalProduct => diagonal.product;

  List<N2Vector<T>> columns() {
    List<List<num>> cols = [];
    for (int i = 0; i < shape[1]; i++) {
      cols.add([]);
      for (int j = 0; j < shape[0]; j++) {
        cols[i].add(data.get([j, i]));
      }
    }
    return cols.map((e) => N2Vector<T>(N2DList(e as List<T>, [e.length]))).toList();
  }

  List<N2Vector<T>> rows() { // todo not tested
    List<List<num>> rows = [];
    for (int i = 0; i < shape[0]; i++) {
      for (int j = 0; j < shape[1]; j++) {
        rows[i].add(data.get([i, j]));
      }
    }
    return rows.map((e) => N2Vector(N2DList(e as List<T>, [e.length]))).toList();
  }

  N2Vector row(int i) {
    return rows()[i]; // todo pl optimize
  }

  N2Vector column(int i) {
    return columns()[i]; // todo pl optimize
  }

  String toString() {
    String ret = "";
    // change to iterator
    for (int i = 0; i < shape[0]; i++) {
      ret += row(i).toString();
      if (i != shape[0] - 1) {
        ret += "\n";
      }
    }
    return ret;
  }

  void addColumn(List<T> col) {
    if (col.length != columnLength) {
      throw ArgumentError("Column length must be equal to column length"); //todo what is this error message
    }
    for (int i = rowCount -1; i >= 0; i--) {
      data.insert(rowLength + i, col[i]);
    }
  }

  void addRow(List<T> row) {
    if (row.length != rowLength) {
      throw ArgumentError("Row length must be equal to row length"); // todo what is this error message
    }
    for (int i = 0; i < columnLength; i++) {
      data.add(row[i]);
    }
    List<int> eek = [rowCount + 1, columnCount];
    data.reshape(eek);
  }

  //////////////////// Matrix operations ////////////////////

  N2Matrix transpose() {
    List<num> vals = [];
    for (int i = 0; i < shape[1]; i++) {
      for (int j = 0; j < shape[0]; j++) {
        vals.add(this.get([j, i]));
      }
    }
    return N2Matrix(N2DList(vals, shape));
  }

  (N2Matrix L, N2Matrix U) luDecomposition() {
    if (shape[0] != shape[1]) {
      throw Exception("NN2Matrix must be square");
    }
    N2Matrix L = N2Matrix.identity(this.shape[0]);
    N2Matrix U = N2Matrix.zeroes(shape);
    for (int i = 0; i < shape[0]; i++) {
      for (int j = i; j < shape[0]; j++) {
        num sum = 0;
        for (int k = 0; k < i; k++) {
          sum += L.get([i, k]) * U.get([k, j]);
        }
        U.set([i, j],this.get([i, j]) - sum);
      }
      for (int j = i; j < shape[0]; j++) {
        num sum = 0;
        for (int k = 0; k < i; k++) {
          sum += L.get([j, k]) * U.get([k, i]);
        }
        L.set([j, i],(this.get([j, i]) - sum) / U.get([i, i]));
      }
    }
    return (L, U);
  }

  (N2Matrix Q, N2Matrix R) qrDecomposition() {
    N2Matrix Gram = this.gramSchmidt();
    List<N2Vector> values = [];
    for (int i = 0; i < shape[0]; i++) {
      values.add(Gram.column(i) / Gram.column(i).norm(2));
    }
    N2Matrix Q = N2Matrix.columnsInit(values);
    N2Matrix R = Q.transpose().dotM(this);
    return (Q, R);
  }

  N2Matrix gramSchmidt() {
    List<N2Vector> basis = [column(0)];
    for (int i = 1; i < shape[0]; i++) {
      N2Vector v = column(i);
      var x = v;
      for (int j = 0; j < i; j++) {
        x = x - v.proj(basis[j]);//(basis[j] * (basis[j].dot(v) / basis[j].dot(basis[j])));
      }
      basis.add(x);
    }
    return N2Matrix.columnsInit(basis);
  }

  List<num> eigenvalues({double tol = 0.001, int max_iterations = 10000}) {
    N2Matrix A = N2Matrix(data.copy());
    for (int k = 0; k < max_iterations; k++) {
      (N2Matrix, N2Matrix) QR = A.qrDecomposition();
      A = QR.$2.dotM(QR.$1);

      // check convergence
      num off_diagonal_norm = 0;
      for (int i = 0; i < A.shape[0]; i++) {
        for (int j = 0; j < A.shape[1]; j++) {
          if (i != j) {
            off_diagonal_norm += math.pow(A.get([i, j]), 2);
          }
        }
      }
      if (math.sqrt(off_diagonal_norm) < tol) {
        break;
      }
    }

    List<num> eeigenvalues = [];
    for (int i = 0; i < A.shape[0]; i++) {
      eeigenvalues.add(A.get([i, i]));
    }
    return eeigenvalues;

  }

  num get det => luDecomposition().$2.diagonalProduct;

  N2Vector forwardSubstitution(N2Vector b) { // todo not tested
    N2Vector y = N2Vector.zeroes(this.shape[0]); // todo shape might be wrong
    for (int i = 0; i < this.shape[0]; i++) {
      double sum = 0.0;
      for (int k = 0; k < i; k++) {
        sum += get([i, k]) * y[k];
      }
      y[i] = (b[i] - sum) / get([i,i]);
    }
    return y;
  }

  N2Vector backwardSubstitution(N2Vector y) { // todo not tested
    N2Vector x = N2Vector.zeroes(shape[0]);
    for(int i = shape[0] -1; i >= 0; i--) {
      double sum = 0.0;
      for (int k = i+1; k < shape[0]; k++) {
        sum += get([i,k]) * x[k];
      }
      x[i] = (y[i] - sum) / get([i,i]);
    }
    return x;
  }

  N2Matrix? get inverse  { // todo test
    N2Matrix I = N2Matrix.identity(shape[0]);
    (N2Matrix, N2Matrix) LU = luDecomposition();
    N2Matrix inv = N2Matrix.zeroes(shape);

    for (int i = 0; i < shape[0]; i++) {
      N2Vector y = LU.$1.forwardSubstitution(I.column(i)); // row or column ??
      N2Vector x = LU.$2.backwardSubstitution(y);
      for (int j=0; j < shape[0]; j++) {
        inv.set([j,i], x[j]);
      }
    }
    return inv;
  }

  @override
  N2DMathArray<T> dot(N2DMathArray<T> other) {
    // TODO: implement dot
    throw UnimplementedError();
  }


}

class N2BinMatrix with N2DArrayMathMixin<int> {
  N2DataLstMixin<int> data;

  N2BinMatrix(this.data);

  @override
  N2Data<int> copy() {
    // TODO: implement copy
    throw UnimplementedError();
  }

  @override
  N2DMathArray<int> dot(N2DMathArray<int> other) {
    // TODO: implement dot
    throw UnimplementedError();
  }

  @override
  double infinityNorm() {
    // TODO: implement infinityNorm
    throw UnimplementedError();
  }

  @override
  double norm(int value) {
    // TODO: implement norm
    throw UnimplementedError();
  }

  @override
  String get type => "BinMatrix";


  N2Vector<num> dotV(N2Vector<num> v) {
    if (data.shape[1] != v.data.length) {
      throw Exception('Matrix and vector must have same length');
    }
    List<num> vals = [];
    for (int i = 0; i < data.shape[0]; i++) {
      num sum = 0;
      for (int j = 0; j < data.shape[1]; j++) {
        sum += data.get([i, j]) * v.data[j];
      }
      vals.add(sum);
    }
    return N2Vector.fromList(vals);
  }
}

























