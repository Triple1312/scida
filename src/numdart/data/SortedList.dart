

import 'package:collection/collection.dart';

class Sortedlist<T> extends DelegatingList<T> {

  late int Function(T, T) _compare;

  Sortedlist([int Function(T, T)? compareFunc]) : super(<T>[]) {
    if (compareFunc != null) {
      _compare = compareFunc;
    }
    else {
      _compare = defaultCompare;
    }
  }

  int defaultCompare(T a, T b) {
    assert(a is num, "for default compare, a should be a number");
    assert(b is num, "for default compare, b should be a number");
    num a2 = a as num;
    num b2 = b as num;
    if (b2 == a2) {
      return 0;
    } else if (a2 > b2) {
      return 1;
    } else {
      return -1;
    }
  }

  @override
  void add(T value) {
    for (int i = 0; i < length; i++) {
      if (_compare(this[i], value) > 0) {
        insert(i, value);
        return;
      }
    }
    insert(length, value);
  }

  @override
  void addAll(Iterable<T> iterable) {
    for (T value in iterable) {
      add(value);
    }
  }
























}