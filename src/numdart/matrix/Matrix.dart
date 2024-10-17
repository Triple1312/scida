


import 'dart:math' as math;

import '../data/NData.dart';
import 'NMatrixIteraotors.dart';
import '../data/NNDarray.dart';
import '../data/NDNumbers.dart';
import '../vector/Vector.dart';

class Matrix extends NNDarray<num> with NMatrixIteratable implements NDMatharray {

  late NData<num> data;

  Matrix(this.data);

  Matrix.zeroes(List<int> shape) { // todo add other data types
    data = NumNList(new List<num>.filled(shape.fold(1, (a, b) => a* b), 0), shape);
  }

  Matrix.empty() {
    data = NumNList([], [0, 0]);
  }

  @override
  Matrix operator *(num scalar) {
    return Matrix(data * scalar);
  }

  Matrix operator +(Matrix other) {
    return Matrix(data + other.data);
  }

  // @override
  Matrix operator -(Matrix other) {
    return Matrix(data - other.data);
  }

  @override
  Matrix operator /(num scalar) {
    return Matrix(data / scalar);
  }

  int get rowLength => shape[0];

  int get columnLength => shape[1];

  int get rowCount => shape[1];

  int get columnCount => shape[0];

  @override
  NumNDarray cross(NumNDarray other) {
    // TODO: implement cross
    throw UnimplementedError();
  }

  // @override
  Matrix dot(Matrix m) { // todo fix multidimensional
    Matrix met = this.copy;
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

  Vector get diagonal  {
    List<num> vals = [];
    for (int i = 0; i < shape[0]; i++) {
      vals.add(data.get([i, i]));
    }
    return Vector(NumNList(vals, [shape[0]]));
  }

  num get diagonalSum {
    return diagonal.sum;
  }

  num get trace => diagonalSum;

  num get diagonalProduct {
    return diagonal.product;
  }

  @override
  num infinityNorm() {
    // TODO: implement infinityNorm
    throw UnimplementedError();
  }

  @override
  num norm(int p) {
    // TODO: implement norm
    throw UnimplementedError();
  }

  Matrix get copy => Matrix(data.copy);

  NMatrixIt<Vector> get rowIterator => NMatrixIt(rows()); // todo could be more efficient

  NMatrixIt<Vector> get columnIterator => NMatrixIt(columns()); // todo could be more efficient

  List<Vector> columns() {
    List<List<num>> cols = [];
    for (int i = 0; i < shape[1]; i++) {
      cols.add([]);
      for (int j = 0; j < shape[0]; j++) {
        cols[i].add(data.get([j, i]));
      }
    }
    return cols.map((e) => Vector(NumNList(e, [e.length]))).toList();
  }

  List<Vector> rows() { // todo not tested
    List<List<num>> rows = [];
    for (int i = 0; i < shape[0]; i++) {
      for (int j = 0; j < shape[1]; j++) {
        rows[i].add(data.get([i, j]));
      }
    }
    return rows.map((e) => Vector(NumNList(e, [e.length]))).toList();
  }

  Vector row(int i) {
    return rows()[i]; // todo pl optimize
  }

  Vector column(int i) {
    return columns()[i]; // todo pl optimize
  }

  
  Matrix.columnsInit(List<Vector> basis) { // todo no idea if works
    List<num> vals = [];
    for (int i = 0; i < basis.length; i++) {
      for (int j = 0; j < basis[0].size; j++) {
        vals.add(basis[j][i]);
      }
    }
    data = NumNList(vals, [basis[0].size, basis.length]);
  }

  Matrix.identity(int size) {
    data = NumNList(List.generate(size * size, (i) => i % (size + 1) == 0 ? 1 : 0), [size, size]);
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

  void addColumn(List<num> col) {
    if (col.length != columnLength) {
      throw ArgumentError("Column length must be equal to column length"); //todo what is this error message
    }
    for (int i = rowCount -1; i >= 0; i--) {
      data.insert(rowLength + i, col[i]);
    }
  }

  void addRow(List<num> row) {
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

  Matrix transpose() {
    List<num> vals = [];
    for (int i = 0; i < shape[1]; i++) {
      for (int j = 0; j < shape[0]; j++) {
        vals.add(this.get([j, i]));
      }
    }
    return Matrix(NumNList(vals, shape));
  }

  (Matrix L, Matrix U) luDecomposition() {
    if (shape[0] != shape[1]) {
      throw Exception("NMatrix must be square");
    }
    Matrix L = Matrix.identity(this.shape[0]);
    Matrix U = Matrix.zeroes(shape);
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

  (Matrix Q, Matrix R) qrDecomposition() {
    Matrix Gram = this.gramSchmidt();
    List<Vector> values = [];
    for (int i = 0; i < shape[0]; i++) {
      values.add(Gram.column(i) / Gram.column(i).norm(2));
    }
    Matrix Q = Matrix.columnsInit(values);
    Matrix R = Q.transpose().dot(this);
    return (Q, R);
  }

  Matrix gramSchmidt() {
    List<Vector> basis = [column(0)];
    for (int i = 1; i < shape[0]; i++) {
      Vector v = column(i);
      var x = v;
      for (int j = 0; j < i; j++) {
        x = x - v.proj(basis[j]);//(basis[j] * (basis[j].dot(v) / basis[j].dot(basis[j])));
      }
      basis.add(x);
    }
    return Matrix.columnsInit(basis);
  }

  List<num> eigenvalues({double tol = 0.001, int max_iterations = 10000}) {
    Matrix A = copy;
    for (int k = 0; k < max_iterations; k++) {
      (Matrix, Matrix) QR = A.qrDecomposition();
      A = QR.$2.dot(QR.$1);

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

  Vector forwardSubstitution(Vector b) { // todo not tested
    Vector y = Vector.zeroes(this.shape[0]); // todo shape might be wrong
    for (int i = 0; i < this.shape[0]; i++) {
      double sum = 0.0;
      for (int k = 0; k < i; k++) {
        sum += get([i, k]) * y[k];
      }
      y[i] = (b[i] - sum) / get([i,i]);
    }
    return y;
  }

  Vector backwardSubstitution(Vector y) { // todo not tested
    Vector x = Vector.zeroes(shape[0]);
    for(int i = shape[0] -1; i >= 0; i--) {
      double sum = 0.0;
      for (int k = i+1; k < shape[0]; k++) {
        sum += get([i,k]) * x[k];
      }
      x[i] = (y[i] - sum) / get([i,i]);
    }
    return x;
  }

  Matrix? get inverse  { // todo test
    Matrix I = Matrix.identity(shape[0]);
    (Matrix, Matrix) LU = luDecomposition();
    Matrix inv = Matrix.zeroes(shape);

    for (int i = 0; i < shape[0]; i++) {
      Vector y = LU.$1.forwardSubstitution(I.column(i)); // row or column ??
      Vector x = LU.$2.backwardSubstitution(y);
      for (int j=0; j < shape[0]; j++) {
        inv.set([j,i], x[j]);
      }
    }
    return inv;
  }

  Matrix pow(int k) => new List<int>.generate(k, (i) => i).fold(Matrix.identity(size), (a, b) => a.dot(this)); // todo test

  Matrix cholekyDecomposition() {
    throw UnimplementedError();
  }

  int get rank => throw UnimplementedError();

  num exp(num k) {throw UnimplementedError();}

  Matrix log() {throw UnimplementedError();}

  (Matrix, Matrix, Matrix) diagonalization() {throw UnimplementedError();}

}
