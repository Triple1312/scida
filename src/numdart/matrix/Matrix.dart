


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
  
  Matrix.columnsInit(List<Vector> basis) { // todo no idea if works
    List<num> vals = [];
    for (int i = 0; i < basis.length; i++) {
      for (int j = 0; j < basis[0].size; j++) {
        vals.add(basis[j][i]);
      }
    }
    data = NumNList(vals, [basis[0].size, basis.length]);
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

}
