
import 'dart:math';


import 'package:collection/collection.dart';

import 'Tensor.dart';


class Vector<T extends num> implements Tensor<T> , List<T> {

  List<T> _base = [];

  Vector.empty() : _base = [];

  Vector.zeroes(int length) : _base = List<T>.filled(length, 0 as T);

  // factory Vector.sparse_zeroes(int length) => SparceVector.zeroes(length);
  //
  // factory Vector.sparce(List<T> base) => SparceVector(base);

  Vector(List<T> values) : _base = values;

  List<T> get flat => _base;



  @override
  T get(List<int> indices) {
    if (indices.length != 1) {
      throw Exception("Invalid number of indices");
    }
    return _base[indices[0]];
  }

  @override
  void set(List<int> indices, T value) {
    // TODO: implement set
  }

  ///////////////////////// operators /////////////////////////

  Vector<num> operator *(num scalar) {
    return Vector<num>(_base.map((e) => e * scalar).toList());
  }

  Vector<num> operator /(num scalar) {
    return Vector<num>(_base.map((e) => e / scalar).toList());
  }


  ///////////////////////// Math /////////////////////////

  num dot(Vector v) {
    if (shape[0] != v.shape[0]) {
      throw Exception("Vectors must be same size");
    }
    num x = List.generate(shape[0], (i) => this[i] * v[i]).fold(0, (a, b) => a + b);
    return List.generate(shape[0], (i) => this[i] * v[i]).fold(0, (a, b) => a + b);
  }

  Vector proj(Vector v) {
    return v * (v.dot(this) / v.dot(v));
  }

  T get sum => _base.fold(0 as T, (a, b) => (a + b) as T);

  T get product => _base.fold(1 as T, (a, b) => (a * b) as T);

  num get mean => sum / length;

  num get median => { // todo test
    if (length % 2 == 0) {
      (_base[length ~/ 2] + _base[(length ~/ 2) + 1]) / 2
    } else {
      _base[length ~/ 2]
    }
  } as num;

  Vector<num> minusVector(Vector<num> other) {
    if (length != other.length) {
      throw Exception("Vectors must be same size");
    }
    return Vector<num>(List.generate(length, (i) => this[i] - other[i] ));
  }

  Vector<num> plusVector(Vector<num> other) {
    if (length != other.length) {
      throw Exception("Vectors must be same size");
    }
    return Vector<num>(List.generate(length, (i) => this[i] + other[i]));
  }

  @override
  num infinityNorm() {
    // TODO: implement infinityNorm
    throw UnimplementedError();
  }

  @override
  num norm(int p) {
    return pow(this.fold(0, (a,b) => a+ pow(b.abs(),p)), 1/p);
  }


  ///////////////////////// List overrides /////////////////////////

  @override
  bool any(bool Function(T) test) => _base.any(test);

  @override
  List<T> cast<T>() => _base.cast<T>();

  @override
  bool contains(Object? element) => _base.contains(element);

  @override
  T elementAt(int index) => _base.elementAt(index);

  @override
  bool every(bool Function(T) test) => _base.every(test);

  @override
  Iterable<K> expand<K>(Iterable<K> Function(T) f) => _base.expand(f);

  @override
  T get first => _base.first;

  @override
  T firstWhere(bool Function(T) test, {T Function()? orElse}) =>
      _base.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      _base.fold(initialValue, combine);

  @override
  Iterable<T> followedBy(Iterable<T> other) => _base.followedBy(other);

  @override
  void forEach(void Function(T) f) => _base.forEach(f);

  @override
  bool get isEmpty => _base.isEmpty;

  @override
  bool get isNotEmpty => _base.isNotEmpty;

  @override
  Iterator<T> get iterator => _base.iterator;

  @override
  String join([String separator = '']) => _base.join(separator);

  @override
  T get last => _base.last;

  @override
  T lastWhere(bool Function(T) test, {T Function()? orElse}) =>
      _base.lastWhere(test, orElse: orElse);

  @override
  int get length => _base.length;

  @override
  Iterable<E> map<E>(E Function(T) f) => _base.map(f);

  @override
  T reduce(T Function(T value, T element) combine) => _base.reduce(combine);

  @override
  T get single => _base.single;

  @override
  T singleWhere(bool Function(T) test, {T Function()? orElse}) {
    return _base.singleWhere(test, orElse: orElse);
  }

  @override
  Iterable<T> skip(int n) => _base.skip(n);

  @override
  Iterable<T> skipWhile(bool Function(T) test) => _base.skipWhile(test);

  @override
  Iterable<T> take(int n) => _base.take(n);

  @override
  Iterable<T> takeWhile(bool Function(T) test) => _base.takeWhile(test);

  @override
  List<T> toList({bool growable = true}) => _base.toList(growable: growable);

  @override
  Set<T> toSet() => _base.toSet();

  @override
  Iterable<T> where(bool Function(T) test) => _base.where(test);

  @override
  Iterable<T> whereType<T>() => _base.whereType<T>();

  @override
  String toString() => _base.toString();

  @override
  T operator [](int index) => _base[index];

  @override
  void operator []=(int index, T value) {
    _base[index] = value;
  }

  @override
  List<T> operator +(List<T> other) => _base + other;

  @override
  void add(T value) {
    _base.add(value);
  }

  @override
  void addAll(Iterable<T> iterable) {
    _base.addAll(iterable);
  }

  @override
  Map<int, T> asMap() => _base.asMap();

  @override
  void clear() {
    _base.clear();
  }

  @override
  void fillRange(int start, int end, [T? fillValue]) {
    _base.fillRange(start, end, fillValue);
  }

  @override
  set first(T value) {
    if (isEmpty) throw RangeError.index(0, this);
    this[0] = value;
  }

  @override
  Iterable<T> getRange(int start, int end) => _base.getRange(start, end);

  @override
  int indexOf(T element, [int start = 0]) => _base.indexOf(element, start);

  @override
  int indexWhere(bool Function(T) test, [int start = 0]) =>
      _base.indexWhere(test, start);

  @override
  void insert(int index, T element) {
    _base.insert(index, element);
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    _base.insertAll(index, iterable);
  }

  @override
  set last(T value) {
    if (isEmpty) throw RangeError.index(0, this);
    this[length - 1] = value;
  }

  @override
  int lastIndexOf(T element, [int? start]) => _base.lastIndexOf(element, start);

  @override
  int lastIndexWhere(bool Function(T) test, [int? start]) =>
      _base.lastIndexWhere(test, start);

  @override
  set length(int newLength) {
    _base.length = newLength;
  }

  @override
  bool remove(Object? value) => _base.remove(value);

  @override
  T removeAt(int index) => _base.removeAt(index);

  @override
  T removeLast() => _base.removeLast();

  @override
  void removeRange(int start, int end) {
    _base.removeRange(start, end);
  }

  @override
  void removeWhere(bool Function(T) test) {
    _base.removeWhere(test);
  }

  @override
  void replaceRange(int start, int end, Iterable<T> iterable) {
    _base.replaceRange(start, end, iterable);
  }

  @override
  void retainWhere(bool Function(T) test) {
    _base.retainWhere(test);
  }

  @override
  Iterable<T> get reversed => _base.reversed;

  @override
  void setAll(int index, Iterable<T> iterable) {
    _base.setAll(index, iterable);
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    _base.setRange(start, end, iterable, skipCount);
  }

  @override
  void shuffle([Random? random]) {
    _base.shuffle(random);
  }

  @override
  void sort([int Function(T, T)? compare]) {
    _base.sort(compare);
  }

  @override
  List<T> sublist(int start, [int? end]) => _base.sublist(start, end);

  @override
  List<int> get shape => [_base.length];

}


// class SparceVector<T extends num> extends Vector<T> {
//
//   List<int> _indices = [];
//
//   SparceVector.zeroes(int length) : super(List.generate(length, (i) => 0 as T));
//
//
//   SparceVector(List<T> base) : super([base.length]);
//
// }
