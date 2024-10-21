

import 'dart:core';
import 'dart:math';

import 'package:meta/meta.dart';
import 'package:collection/collection.dart';

import 'NData.dart';

class NDList<T> extends DelegatingList<T> implements NData<T>{

  NDList() : super(<T>[]);

  @override
  List<int> shape;

  @override
  int size;

  @override
  // TODO: implement copy
  get copy => throw UnimplementedError();

  @override
  // TODO: implement depth
  int get depth => throw UnimplementedError();

  @override
  List<T> diagonal() {
    // TODO: implement diagonal
    throw UnimplementedError();
  }

  @override
  void fill(T value) {
    // TODO: implement fill
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






  /////////////////////////////////// List methods ///////////////////////////////////

  // @override
  // T get first => data.first;
  //
  // @override
  // T get last => data.last;
  //
  // @override
  // int get length => data.length;
  //
  // @override
  // List<T> operator +(List<T> other) => data + other;
  //
  // @override
  // T operator [](int index) => data[index];
  //
  // @override
  // void operator []=(int index, T value) => data[index] = value;
  //
  // @override
  // void add(T value) => data.add(value);
  //
  // @override
  // void addAll(Iterable<T> iterable) => data.addAll(iterable);
  //
  // @override
  // bool any(bool Function(T element) test) => data.any(test);
  //
  // @override
  // Map<int, T> asMap() => data.asMap();
  //
  // @override
  // List<R> cast<R>() => data.cast<R>();
  //
  // @override
  // void clear() => data.clear();
  //
  // @override
  // bool contains(Object? element) => data.contains(element);
  //
  // @override
  // T elementAt(int index) => data.elementAt(index);
  //
  // @override
  // bool every(bool Function(T element) test) => data.every(test);
  //
  // @override
  // Iterable<T> expand<T>(Iterable<T> Function(T element) toElements) => data.expand(toElements);
  //
  // @override
  // void fillRange(int start, int end, [T? fillValue]) => data.fillRange(start, end, fillValue);
  //
  // @override
  // T firstWhere(bool Function(T element) test, {T Function()? orElse}) => data.firstWhere(test, orElse: orElse);
  //
  // @override
  // T fold<T>(T initialValue, T Function(T previousValue, T element) combine) => data.fold<T>(initialValue, combine);
  //
  // @override
  // Iterable<T> followedBy(Iterable<T> other) => data.followedBy(other);
  //
  // @override
  // void forEach(void Function(T element) action) => data.forEach(action);
  //
  // @override
  // Iterable<T> getRange(int start, int end) => data.getRange(start, end);
  //
  // @override
  // int indexOf(T element, [int start = 0]) => data.indexOf(element, start);
  //
  // @override
  // int indexWhere(bool Function(T element) test, [int start = 0]) => data.indexWhere(test, start);
  //
  // @override
  // void insert(int index, T element) => data.insert(index, element);
  //
  // @override
  // void insertAll(int index, Iterable<T> iterable) => data.insertAll(index, iterable);
  //
  // @override
  // bool get isEmpty => data.isEmpty;
  //
  // @override
  // bool get isNotEmpty => data.isNotEmpty;
  //
  // @override
  // Iterator<T> get iterator => data.iterator;
  //
  // @override
  // String join([String separator = ""]) => data.join(separator);
  //
  // @override
  // int lastIndexOf(T element, [int? start]) => data.lastIndexOf(element, start);
  //
  // @override
  // int lastIndexWhere(bool Function(T element) test, [int? start]) => data.lastIndexWhere(test, start);
  //
  // @override
  // T lastWhere(bool Function(T element) test, {T Function()? orElse}) => data.lastWhere(test, orElse: orElse);
  //
  // @override
  // Iterable<T> map<T>(T Function(T e) toElement) => data.map(toElement);
  //
  // @override
  // T reduce(T Function(T value, T element) combine) => data.reduce(combine);
  //
  // @override
  // bool remove(Object? value) => data.remove(value);
  //
  // @override
  // T removeAt(int index) => data.removeAt(index);
  //
  // @override
  // T removeLast() => data.removeLast();
  //
  // @override
  // void removeRange(int start, int end) => data.removeRange(start, end);
  //
  // @override
  // void removeWhere(bool Function(T element) test) => data.removeWhere(test);
  //
  // @override
  // void replaceRange(int start, int end, Iterable<T> replacements) => data.replaceRange(start, end, replacements);
  //
  // @override
  // void retainWhere(bool Function(T element) test) => data.retainWhere(test);
  //
  // @override
  // Iterable<T> get reversed => data.reversed;
  //
  // @override
  // void setAll(int index, Iterable<T> iterable) => data.setAll(index, iterable);
  //
  // @override
  // void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) => data.setRange(start, end, iterable, skipCount);
  //
  // @override
  // void shuffle([Random? random]) => data.shuffle(random);
  //
  // @override
  // T get single => data.single;
  //
  // @override
  // T singleWhere(bool Function(T element) test, {T Function()? orElse}) => throw UnimplementedError();
  //
  // @override
  // Iterable<T> skip(int count) => data.skip(count);
  //
  // @override
  // Iterable<T> skipWhile(bool Function(T value) test) => data.skipWhile(test);
  //
  // @override
  // void sort([int Function(T a, T b)? compare]) => data.sort(compare);
  //
  // @override
  // List<T> sublist(int start, [int? end]) => data.sublist(start, end);
  //
  // @override
  // Iterable<T> take(int count) => data.take(count);
  //
  // @override
  // Iterable<T> takeWhile(bool Function(T value) test) => data.takeWhile(test);
  //
  // @override
  // List<T> toList({bool growable = true}) => data.toList(growable: growable);
  //
  // @override
  // Set<T> toSet() => data.toSet();
  //
  // @override
  // Iterable<T> where(bool Function(T element) test) => data.where(test);
  //
  // @override
  // Iterable<T> whereType<T>() => data.whereType<T>();
  //
  // @override
  // set first(T value) => data.first = value;
  //
  // @override
  // set last(T value) => data.last = value;
  //
  // @override
  // void set length(int newLength) => data.length = newLength;

}