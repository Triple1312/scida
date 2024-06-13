


import 'dart:math';

import 'NDarray.dart';

num norm(List<double> values, {int p = 2}) {
  return pow(values.fold(0, (a,b) => a+ pow(b.abs(),p)), 1/p);
}

num infinityNorm(List<double> values) {
  return values.fold(0, (a,b) => max(a, b.abs()));
}



class OVector<T extends num> extends NDarray<T>{

  OVector({required super.values});

  OVector.array(List<T> values) : super(values: values);

  get type => T;

  OVector.zeros(int size) : super.zeros([size]);

  OVector.householder(OVector<T> x) : super(values: []){
    OVector<num> e = OVector.zeros(shape[0]);
    e[[0]] = 1;
    OVector<num> v = x - e * x.norm(2);
    values =  (v / v.norm(2)).values as List<T>;
  }

  OVector householder() {
    return OVector.householder(this);
  }

  operator -(OVector<T> other) {
    if (shape[0] != other.shape[0]) {
      throw Exception("Vectors must be same size");
    }
    return OVector(values: List.generate(shape[0], (i) => this[[i]] - other[[i]]));
  }

  operator *(num scalar) {
    return OVector(values: List.generate(shape[0], (i) => this[[i]] * scalar));
  }

  operator /(num scalar) {
    return OVector(values: List.generate(shape[0], (i) => this[[i]] / scalar));
  }

  operator +(OVector<T> other) {
    if (shape[0] != other.shape[0]) {
      throw Exception("Vectors must be same size");
    }
    return OVector(values: List.generate(shape[0], (i) => this[[i]] + other[[i]]));
  }


  num get sum => values.fold(0, (a, b) => a + b);

  @override
  String toString() => values.fold('[', (a, b) => a + b.toString() + ', ').trimRight().replaceFirst(RegExp(r',$'), '') + ']';

  num dot(OVector<T> other) {
    if (shape[0] != other.shape[0]) {
      throw Exception("Vectors must be same size");
    }
    num x = List.generate(shape[0], (i) => this[[i]] * other[[i]]).fold(0, (a, b) => a + b);
    return List.generate(shape[0], (i) => this[[i]] * other[[i]]).fold(0, (a, b) => a + b);
  }



}