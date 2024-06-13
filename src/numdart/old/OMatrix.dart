


import 'dart:math';

import '../NDarray.dart';
import 'multiarray.dart';
import '../OVector.dart';
import 'special_matrices.dart';

class OMatrix<T extends num> extends NDarray<T> {

  OMatrix(List<T> values, List<int> shape): super.array(values: values, shape: shape);

  static NDarray tensor() {
    return NDarray(values: []);
  }

  OMatrix.zeros(List<int> shape): super.zeros(shape) {
    if (shape.length != 2) {
      throw Exception("Matrix must be 2D");
    }
  }

  @override
  void reshape(List<int> dimensions) {
    if (dimensions.length != 2) {
      throw Exception("Matrix must be 2D");
    }
    super.reshape(dimensions);
  }


  OMatrix.fromNDarray(NDarray<T> nda) : super.upgrade(nda) {
    if (nda.shape.length != 2) {
      throw Exception("Matrix must be 2D");
    }
  }

  OMatrix.columns(List<OVector<T>> vs) : super.zeros([vs.length , vs[0].length]) {
    List<T> vals = [];
    for (int i = 0; i < vs.length; i++) {
      for (int j = 0; j < vs[0].length; j++) {
        vals.add(vs[j][[i]]);
      }
    }
    values = vals;
  }

  (OMatrix L, OMatrix U) luDecomposition() {
    if (shape[0] != shape[1]) {
      throw Exception("Matrix must be square");
    }
    OMatrix<num> L = OMatrix.identity(this.shape[0]);
    OMatrix<num> U = OMatrix.zeros(shape);
    for (int i = 0; i < shape[0]; i++) {
      for (int j = i; j < shape[0]; j++) {
         num sum = 0;
         for (int k = 0; k < i; k++) {
           sum += L[[i, k]] * U[[k, j]];
         }
         U[[i, j]] = this[[i, j]] - sum;
      }
      for (int j = i; j < shape[0]; j++) {
        num sum = 0;
        for (int k = 0; k < i; k++) {
          sum += L[[j, k]] * U[[k, i]];
        }
        L[[j, i]] = (this[[j, i]] - sum) / U[[i, i]];
      }
    }
    return (L, U);
  }


  (OMatrix<num> Q, OMatrix<num> R) qrDecomposition() {
    OMatrix<num> Gram = this.gramSchmidt();
    List<OVector<num>> values = [];
    for (int i = 0; i < shape[0]; i++) {
      var x = Gram.column(i);
      values.add(Gram.column(i) / Gram.column(i).norm(2));
    }
    OMatrix<num> Q = OMatrix.columns(values);
    OMatrix<num> R = Q.transpose() * this;
    return (Q, R);
  }

  (OMatrix<num> Q, OMatrix<num> R) qrDecomposition_old() {
    OMatrix<num> R = OMatrix.fromNDarray(this);
    OMatrix<num> Q = OMatrix.identity(shape[0]);
    for (int j = 0; j < shape[1]; j++) {
      num normx = R.column(j).norm(2);

      OVector<num> v = OVector.zeros(shape[0]);
      v[[j]] = R[[j, j]] + normx * R[[j, j]].sign;
      for (int i = j + 1; i < shape[0]; i++) {
        v[[i]] = R[[i, j]];
      }

      num normv = v.norm(2);
      for (int i = j; i < shape[0]; i++) {
        v[[i]] = v[[i]] / normv;
      }

      for (int k = j; k < shape[1]; k++) {
        num s = 0;
        for (int i = j; i < shape[0]; i++) {
          s += v[[i]] * R[[i, k]];
        }
        for (int i = j; i < shape[0]; i++) {
          R[[i, k]] = R[[i, k]] - 2 * v[[i]] * s;
        }
      }

      for (int k = 0; k < shape[0]; k++) {
        num s = 0;
        for (int i = j; i < shape[0]; i++) {
          s += v[[i]] * Q[[i, k]];
        }
        for (int i = j; i < shape[0]; i++) {
          Q[[i, k]] = Q[[i, k]] - 2 * v[[i]] * s;
        }
      }

    }
    return (Q, R);
  }

  // (Matrix<num> U, Matrix<num> S, Matrix<num> V) svd() {
  //
  // }

  List<num> QREigenvalues({double tol = 0.001, int max_iterations = 300}) {
    OMatrix A = OMatrix.fromNDarray(this);
    for (int k = 0; k < max_iterations; k++) {
      (OMatrix, OMatrix) QR = A.qrDecomposition();
      A = QR.$1 * QR.$2;

      // check convergence
      num off_diagonal_norm = 0;
      for (int i = 0; i < A.shape[0]; i++) {
        for (int j = 0; j < A.shape[1]; j++) {
          if (i != j) {
            off_diagonal_norm += pow(A[[i, j]], 2);
          }
        }
      }
      if (sqrt(off_diagonal_norm) < tol) {
        break;
      }
    }

    List<num> eigenvalues = [];
    for (int i = 0; i < A.shape[0]; i++) {
      eigenvalues.add(A[[i, i]]);
    }
    return eigenvalues;

  }

  OMatrix.identity(int size) : super.identity(size, 2);

  OVector<num> column(int index) { // todo test
    if (index >= shape[1]) {
      throw Exception("Index out of bounds");
    }
    return OVector.array(List.generate(shape[0], (i) => this[[i, index]]));
  }

  OMatrix operator *(OMatrix<T> other) {
    return dot(other);
  }

  num get det => luDecomposition().$1.diagonal_product;

  OVector<num> get diagonal {
    OVector vec = OVector.zeros(min(shape[0], shape[1]));
    int mini = min(shape[0], shape[1]);
    for (int i = 0; i < mini; i++) {
      vec[[i]] = this[[i, i]];
    }
    return vec;
  }

  num get diagonal_sum { // todo could be more efficient
    return diagonal.sum;
  }

  num get diagonal_product { // todo could be more efficient
    return diagonal.values.fold(1, (a, b) => a * b);
  }

  OVector<num> row(int index) {
    if (index >= shape[0]) {
      throw Exception("Index out of bounds");
    }
    return OVector(values: values.sublist(index * shape[1], (index + 1) * shape[1]));
  }

  Iterator<OVector<num>> get iterator => _MatrixRowIterator(this);

  @override
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

  OMatrix<num> gramSchmidt() {
    List<OVector<num>> basis = [column(0)];
    for (int i = 1; i < shape[0]; i++) {
      OVector<num> v = column(i);
      var x = v;
      for (int j = 0; j < i; j++) {
        x = x - (basis[j] * (basis[j].dot(v) / basis[j].dot(basis[j])));
      }
      basis.add(x);
    }
    return OMatrix<num>.columns(basis);
  }

  OMatrix<num> transpose() {
    List<num> vals = [];
    for (int i = 0; i < shape[1]; i++) {
      for (int j = 0; j < shape[0]; j++) {
        vals.add(this[[j, i]]);
      }
    }
    return OMatrix<num>(vals, [shape[1], shape[0]]);

  }

  OMatrix<num> dot(OMatrix<num> m) {
    OMatrix<num> met = this.copy;
    for (int i = 0; i < shape[0]; i++) {
      for (int j = 0; j < shape[1]; j++) {
        num sum = 0;
        for (int k = 0; k < shape[1]; k++) {
          sum += this[[i, k]] * m[[k, j]];
        }
        met[[i, j]] = sum;
      }
    }
    return met;
  }

  @override
  OMatrix<num> get copy => OMatrix<num>(values.map((e) => e as num).toList(), shape.map((e) => e).toList());

}

class _MatrixRowIterator<E extends OVector<num>> extends NDIterator<E> {
  
  _MatrixRowIterator(OMatrix matrix) : super(matrix);

  OMatrix get matrix => nda as OMatrix;

  @override
  E get current => matrix.row(index) as E;

  @override
  bool moveNext() {
    if (index < matrix.shape[0] - 1) {
      index++;
      return true;
    }
    return false;
  }

}

