


import 'package:meta/meta.dart';

import '../data/NDNumbers.dart';
import '../data/NData.dart';

abstract class NNDarray<T> {

  @protected
  NData<T> get data;

  // data getters

  List<int> get shape => data.shape;

  List<T> get flat => data.flat;

  int get size => data.size;

  int get depth => data.depth;

  // data setters

  void fill(T value) => data.fill(value);

  void fillna(T value) => data.fillna(value);

  void fillRange(int start, int end, T value) => data.fillRange(start, end, value);

  void reshape(List<int> dimensions) => data.reshape(dimensions);

  List<T> flatten({String order="C"}) => data.flatten(order: order);

  T get(List<int> loc) => data.get(loc);

  void set(List<int> loc, T value) => data.set(loc, value);

  // void fillUpSize(T value, List<int> shape) => data.fillUpSize(value, shape);

}

abstract class NumNDarray extends NNDarray<num?> {

  @override
  NData<num?> get data;

  @protected
  void set data(NData<num?> data);

  void fillnaMean() => data = data.fillnaMean();

  void fillnaMedian() => data = data.fillnaMedian();

}

abstract interface class NDMatharray {

  NData<num> get data;

  List<int> get shape;

  num norm(int p);

  num infinityNorm();

  // NDMatharray dot(NumNDarray other);

  NumNDarray cross(NumNDarray other);

  // NDMatharray operator +(num other);

  // NDMatharray operator -(num scalar);

  NDMatharray operator *(num scalar);

  NDMatharray operator /(num scalar);

}














