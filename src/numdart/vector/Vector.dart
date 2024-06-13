

import 'dart:math';

import '../data/NData.dart';
import '../data/NNDarray.dart';
import '../data/NDNumbers.dart';

class Vector extends NNDarray<num> implements NDMatharray {

  late NData<num> data;

  Vector(this.data);

  Vector.zeroes(int shape) {
    data = NumNList(new List<num>.filled(shape, 0), [shape]);
  }

  @override
  Vector operator *(num scalar) {
    return Vector(data * scalar);
  }

  @override
  Vector operator +(Vector other) {
    return Vector(data + other.data);
  }

  // @override
  Vector operator -(Vector other) {
    return Vector(data - other.data);
  }

  @override
  Vector operator /(num scalar) {
    return Vector(data / scalar);
  }

  num operator [](int index) {
    return data.get([index]);
  }

  void operator []=(int index, num value) {
    data.set([index], value);
  }

  bool operator ==(Object other) {
    if (other is Vector) {
      return data == other.data;
    }
    return false; // todo list should also work
  }

  // @override
  num dot(Vector v) { // todo fix multidimensional
    if (shape[0] != v.shape[0]) {
      throw Exception("Vectors must be same size");
    }
    num x = List.generate(shape[0], (i) => this[i] * v[i]).fold(0, (a, b) => a + b);
    return List.generate(shape[0], (i) => this[i] * v[i]).fold(0, (a, b) => a + b);
  }

  @override
  NumNDarray cross(NumNDarray other) {
    // TODO: implement cross
    throw UnimplementedError();
  }

  @override
  num infinityNorm() {
    // TODO: implement infinityNorm
    throw UnimplementedError();
  }

  @override
  num norm(int p) {
    return pow(data.fold(0, (a,b) => a+ pow(b.abs(),p)), 1/p);
  }

  Vector proj(Vector v) {
    return v * (v.dot(this) / v.dot(v));
  }

  num get sum => data.sum();

  num get product => data.product();


}