

import '../data/NNDarray.dart';
import '../vector/Vector.dart';

mixin NMatrixIteratable on NNDarray<num> implements Iterable<Vector> {

  List<Vector> columns();

  @override
  bool any(bool Function(Vector element) test) {
    for (Vector element in this) {
      if (test(element)) return true;
    }
    return false;
  }

  @override
  Iterable<R> cast<R>() {
    // TODO: implement cast
    throw UnimplementedError();
  }

  @override
  bool contains(Object? element) {
    for (Vector v in this) {
      if (v == element) return true;
    }
    return false;
  }

  @override
  Vector elementAt(int index) {
    // TODO: implement elementAt
    throw UnimplementedError();
  }

  @override
  bool every(bool Function(Vector element) test) {
    // TODO: implement every
    throw UnimplementedError();
  }

  @override
  Iterable<T> expand<T>(Iterable<T> Function(Vector element) toElements) {
    // TODO: implement expand
    throw UnimplementedError();
  }

  @override
  Vector get first => throw UnimplementedError();

  @override
  Vector firstWhere(bool Function(Vector element) test, {Vector Function()? orElse}) {
    for (Vector v in this) {
      if (test(v)) return v;
    }
    throw Exception("No element found");
  }

  @override
  T fold<T>(T initialValue, T Function(T previousValue, Vector element) combine) {
    // TODO: implement fold
    throw UnimplementedError();
  }

  @override
  Iterable<Vector> followedBy(Iterable<Vector> other) {
    // TODO: implement followedBy
    throw UnimplementedError();
  }

  @override
  void forEach(void Function(Vector element) action) {
    // TODO: implement forEach
  }

  @override
  // TODO: implement isEmpty
  bool get isEmpty => throw UnimplementedError();

  @override
  // TODO: implement isNotEmpty
  bool get isNotEmpty => throw UnimplementedError();

  @override
  String join([String separator = ""]) {
    // TODO: implement join
    throw UnimplementedError();
  }

  @override
  // TODO: implement last
  Vector get last => throw UnimplementedError();

  @override
  Vector lastWhere(bool Function(Vector element) test, {Vector Function()? orElse}) {
    // TODO: implement lastWhere
    throw UnimplementedError();
  }

  @override
  // TODO: implement length
  int get length => throw UnimplementedError();

  @override
  Iterable<T> map<T>(T Function(Vector e) toElement) {
    // TODO: implement map
    throw UnimplementedError();
  }

  @override
  Vector reduce(Vector Function(Vector value, Vector element) combine) {
    // TODO: implement reduce
    throw UnimplementedError();
  }

  @override
  // TODO: implement single
  Vector get single => throw UnimplementedError();

  @override
  Vector singleWhere(bool Function(Vector element) test, {Vector Function()? orElse}) {
    // TODO: implement singleWhere
    throw UnimplementedError();
  }

  @override
  Iterable<Vector> skip(int count) {
    // TODO: implement skip
    throw UnimplementedError();
  }

  @override
  Iterable<Vector> skipWhile(bool Function(Vector value) test) {
    // TODO: implement skipWhile
    throw UnimplementedError();
  }

  @override
  Iterable<Vector> take(int count) {
    // TODO: implement take
    throw UnimplementedError();
  }

  @override
  Iterable<Vector> takeWhile(bool Function(Vector value) test) {
    // TODO: implement takeWhile
    throw UnimplementedError();
  }

  @override
  List<Vector> toList({bool growable = true}) {
    // TODO: implement toList
    throw UnimplementedError();
  }

  @override
  Set<Vector> toSet() {
    // TODO: implement toSet
    throw UnimplementedError();
  }

  @override
  Iterable<Vector> where(bool Function(Vector element) test) {
    // TODO: implement where
    throw UnimplementedError();
  }

  @override
  Iterable<T> whereType<T>() {
    // TODO: implement whereType
    throw UnimplementedError();
  } // todo fix

  @override
  NMatrixIt<Vector> get iterator => NMatrixIt(this.columns()); // todo fix
}

class NMatrixIt<NVector> implements Iterator<NVector> {
  List<NVector> vecs;
  int index = -1;

  NMatrixIt(this.vecs);

  NVector get current => vecs[index];

  @override
  bool moveNext() {
    if (index < vecs.length - 1) {
      index++;
      return true;
    }
    return false;
  }
}