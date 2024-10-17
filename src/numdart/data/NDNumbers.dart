

import 'NData.dart';
import '../vector/Vector.dart';

extension NumData on NData<num?> {
  NData<num> fillnaMean() {
    for (int i = 0; i < flat.length; i++) { // todo flat might not be optimal
      if (flat[i] == null) {
        flat[i] = mean;
      }
    }
    return this as NData<num>;
  }

  NData<num> fillnaMedian() {
    var median = this.median;
    for (int i = 0; i < flat.length; i++) { // todo flat might not be optimal
      if (flat[i] == null) {
        flat[i] = median;
      }
    }
    return this as NData<num>;
  }

  double get median {
    List<num?> x = flat..sort();
    List<num> y = x.where((element) => element != null).toList() as List<num>;
    if (y.length % 2 == 0) {
      return (y[y.length ~/ 2] + y[y.length ~/ 2 + 1]) / 2;
    }
    else {
      return y[y.length ~/ 2] as double;
    }
  }

  double get mean {
    List<num?> x = flat..sort();
    List<num> y = x.where((element) => element != null).toList() as List<num>;
    return y.fold(0.0, (a, b) => a+b) / y.length;
  }


}


extension NumDataE on NData<num> {

  NData<num> operator +(NData<num> other) {
    NData<num> x = copy;
    var flat = other.flat;
    for (int i = 0; i < flat.length; i++) {
      x[i] = x[i] + flat[i];
    }
    return x;
  }

  NData<num> operator -(NData<num> other) {
    // if (shape != other.shape) { todo
    //   throw Exception("Shapes must be the same");
    // }
    NData<num> x = copy;
    var flat = other.flat;
    for (int i = 0; i < flat.length; i++) {
      x[i] = x[i] - flat[i];
    }
    return x;
  }

  NData<num> operator *(num scalar) {
    NData<num> x = copy;
    for (int i = 0; i < flat.length; i++) {
      x.flat[i] = flat[i] * scalar;
    }
    return x;
  }

  NData<num> operator /(num scalar) {
    NData<num> x = copy;
    for (int i = 0; i < flat.length; i++) {
      x.flat[i] = flat[i] / scalar;
    }
    return x;
  }

  num sum() => flat.fold(0, (a, b) => a + b);

  num product() => flat.fold(1, (a, b) => a * b);
}