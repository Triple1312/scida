
import 'dart:core';

import 'dart:math' as math;

import 'Tensor.dart';
import 'Vector.dart';

class Matrix<T extends num> extends Iterable<Vector<T>> implements Tensor<T> {

  /// The matrix class is a wrapper for the matrix data class
  /// The matrix data class is a class that holds the values of the matrix
  /// Is separate class so I can switch between different matrices without changing the matrix class
  MatrixData<T> data;


  ///////////////////////// Getters /////////////////////////

  List<int> get shape => data.shape;

  List<T> get flat => data.values.fold([], (a, b) => a + b);

  String get type => data.type;


  ///////////////////////// Setters /////////////////////////

  @override
  set shape(List<int> _shape) {
    // TODO: implement shape
  }

  ///////////////////////// Constructors /////////////////////////

  Matrix({List<List<T>> values = const []}) : data = MatrixData(values);

  Matrix.empty(): data = MatrixData.empty();

  Matrix._data(MatrixData<T> data) : data = data;

  Matrix.flat(List<T> values, int rowLength, int columnLength) : data = MatrixData.flat(values, rowLength, columnLength);

  Matrix.zeroes(List<int> shape) : data = MatrixData.flat(List<T>.filled(shape[0] * shape[1], 0 as T), shape[0], shape[1]);

  Matrix.identity(int size) : data = MatrixData.flat(List<T>.generate(size * size, (i) => i % (size + 1) == 0 ? 1 as T : 0 as T), size, size);

  factory Matrix.columnsInit(List<List<T>> values) => Matrix<T>(values: values).transpose; // todo probably make better ?

  factory Matrix.csr({List<List<T>> values = const []}) => Matrix._data(CSRMatrixData(values));

  // factory Matrix.csc({List<List<T>> values = const []}) => Matrix._data(CSCMatrixData(values));

  // factory Matrix.coo({List<List<T>> values = const []}) => Matrix._data(COOMatrixData(values));

  Vector<T> operator [](int index) {
    return row(index);
  }

  void operator []=(int index, List<T> value) {
    if (index >= shape[0]) {
      throw Exception('Index out of bounds');
    }
    if (value.length != shape[1]) {
      throw Exception('Invalid number of values');
    }
    data.values[index] = value;
  }

  Vector<T> row(int index) {
    if (index >= shape[0]) {
      throw Exception('Index out of bounds');
    }
    return data.row(index);
  }

  Vector<T> column(int index) {
    if (index >= shape[1]) {
      throw Exception('Index out of bounds');
    }
    return data.column(index);
  }

  @override
  T get(List<int> indices) {
    if (indices.length != 2) {
      throw Exception('Invalid number of indices for get operation');
    }
    return data.get(indices[0], indices[1]);
  }

  @override
  void set(List<int> indices, T value) {
    if (indices.length != 2) {
      throw Exception('Invalid number of indices for set operation');
    }
    data.set(indices[0], indices[1], value);
  }

  List<Vector<T>> rows() {
    return data.values.map((e) => Vector(e)).toList();
  }

  List<Vector<T>> columns() { // todo idk if works
    List<List<T>> cols = [];
    for (int i = 0; i < shape[1]; i++) {
      cols.add([]);
      for (int j = 0; j < shape[0]; j++) {
        cols[i].add(data.get(j, i));
      }
    }
    return cols.map((e) => Vector(e)).toList();
  }

  ///////////////////////// operators /////////////////////////

  Matrix<num> operator /(num scalar) {
    return Matrix<num>(values: data.values.map((e) => e.map((e) => e / scalar).toList()).toList()); // todo make different version for sparce
  }

  Matrix<num> operator *(num scalar) {
    return Matrix<num>(values: data.values.map((e) => e.map((e) => e * scalar).toList()).toList()); // todo make different version for sparce
  }

  Matrix<num> operator +(Matrix<num> other) {
    if (shape[0] != other.shape[0] || shape[1] != other.shape[1]) {
      throw Exception('Matrices must be same shape');
    }
    return Matrix<num>(values: List.generate(shape[0], (i) => List.generate(shape[1], (j) => data.get(i, j) + other.data.get(i, j))));
  }

  Matrix<num> operator -(Matrix<num> other) {
    if (shape[0] != other.shape[0] || shape[1] != other.shape[1]) {
      throw Exception('Matrices must be same shape');
    }
    return Matrix<num>(values: List.generate(shape[0], (i) => List.generate(shape[1], (j) => data.get(i, j) - other.data.get(i, j))));
  }

  ///////////////////////// Math operations /////////////////////////

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

  Matrix<num> dot(Matrix other) {
    Matrix met = Matrix.flat(this.flat, shape[0], shape[1]);
    for (int i = 0; i < shape[0]; i++) {
      for (int j = 0; j < other.shape[1]; j++) {
        num sum = 0;
        for (int k = 0; k < shape[1]; k++) {
          sum += get([i,k]) * other.get([k,j]);
        }
        met.set([i, j], sum);
      }
    }
    return met;
  }

  Vector get diagonal  {
    List<T> vals = [];
    for (int i = 0; i < shape[0]; i++) {
      vals.add(get([i, i]));
    }
    return Vector<T>(vals);
  }

  num get diagonalSum {
    return diagonal.sum;
  }

  num get trace => diagonalSum;

  num get diagonalProduct {
    return diagonal.product;
  }

  Matrix<T> get transpose => Matrix<T>(values: columns());

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
    Matrix R = Q.transpose.dot(this);
    return (Q, R);
  }

  Matrix gramSchmidt() {
    List<Vector> basis = [column(0)];
    for (int i = 1; i < shape[0]; i++) {
      Vector v = column(i);
      var x = v;
      for (int j = 0; j < i; j++) {
        x = x.minusVector(v.proj(basis[j]));//(basis[j] * (basis[j].dot(v) / basis[j].dot(basis[j])));
      }
      basis.add(x);
    }
    return Matrix.columnsInit(basis);
  }

  List<num> eigenvalues({double tol = 0.001, int max_iterations = 10000}) {
    Matrix A = Matrix.flat(flat, shape[0], shape[1]);
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

  Matrix pow(int k) => new List<int>.generate(k, (i) => i).fold(Matrix.identity(shape[0]), (a, b) => a.dot(this)); // todo test

  Matrix cholekyDecomposition() {
    throw UnimplementedError();
  }

  int get rank => throw UnimplementedError();

  num exp(num k) {throw UnimplementedError();}

  Matrix log() {throw UnimplementedError();}

  (Matrix, Matrix, Matrix) diagonalization() {throw UnimplementedError();}


  ///////////////////////// Iterators /////////////////////////

  @override
  Iterator<Vector<T>> get iterator => MatrixVectorRowIterator(this);

  Iterator<Vector<T>> get rowIterator => MatrixVectorRowIterator(this);

  Iterator<Vector<T>> get columnIterator => MatrixVectorColIterator(this);

}

class MatrixData<T extends num> {

  String get type => 'dense';

  int rowLenght = 0;
  int colLenght = 0;

  List<int> get shape => [rowLenght, colLenght];

  List<List<T>> _values = [];

  List<List<T>> get values => _values;
  
  MatrixData(List<List<T>> this._values): rowLenght = _values.length, colLenght = _values[0].length;

  MatrixData.flat(List<T> values, int rowLength, int columnLength) {
    if (values.length != rowLength * columnLength) {
      throw Exception('Invalid number of values');
    }
    rowLenght = rowLength;
    colLenght = columnLength;
    for (int i = 0; i < rowLength; i++) {
      List<T> row = [];
      for (int j = 0; j < columnLength; j++) {
        row.add(values[i * columnLength + j]);
      }
      _values.add(row);
    }
  }

  T get(int row, int col) {
    return _values[row][col];
  }

  void set(int row, int col, T value) {
    _values[row][col] = value;
  }

  Vector<T> row(int index) {
    return Vector<T>(_values[index]);
  }

  Vector<T> column(int index) {
    return Vector<T>(_values.map((e) => e[index]).toList());
  }

  MatrixData.empty();
  
  factory MatrixData.csr(List<List<T>> values) => CSRMatrixData(values);




}

class FlatMatrixData<T extends num> extends MatrixData<T> {

  List<T> _flat_values = [];

  FlatMatrixData(List<T> values) : super.empty() {
    _flat_values = values;
  }

  List<List<T>> get values {
    List<List<T>> result = [];
    for (int i = 0; i < rowLenght; i++) {
      List<T> row = [];
      for (int j = 0; j < colLenght; j++) {
        row.add(_flat_values[i * colLenght + j]);
      }
      result.add(row);
    }
    return result;
  }

}



class CSRMatrixData<T extends num> extends MatrixData<T> {

  List<T> data = [];
  List<int> indices = [];
  List<int> indptr = [];

  CSRMatrixData(List<List<T>> values) : super.empty() {
    rowLenght = values.length;
    colLenght = values[0].length;
    for (int i = 0; i < values.length; i++) {
      for (int j = 0; j < values[i].length; j++) {
        if (values[i][j] != 0) {
          set(i, j, values[i][j]);
        }
      }
    }
  }

  List<List<T>> get values { // todo check if works
    List<List<T>> result = [];
    for (int i = 0; i < rowLenght; i++) {
      List<T> row = List<T>.filled(colLenght, 0 as T);
      List<int> row_indices = indices.sublist(indptr[i], indptr[i + 1]);
      for (int j = 0; j < row_indices.length; j++) {
        row[row_indices[j]] = data[indptr[i] + j];
      }
      result.add(row);
    }
    return result;
  }

  T get(int row, int col) {
    List<int> row_indices = indices.sublist(indptr[row], indptr[row + 1]);
    if (row_indices.contains(col)) {
      return data[indptr[row] + row_indices.indexOf(col)];
    }
    else {
      return 0 as T;
    }
  }

  void set(int row, int col, T value) {
    List<int> row_indices = indices.sublist(indptr[row], indptr[row + 1]);
    if (value == 0) {
      if (row_indices.contains(col)) {
        int index = indptr[row] + row_indices.indexOf(col);
        data.removeAt(index);
        indices.removeAt(index);
        indptr = indptr.map((e) => e > index ? e - 1 : e).toList();
      }
    }
    else {
      if (row_indices.contains(col)) {
        data[indptr[row] + row_indices.indexOf(col)] = value;
      }
      else {
        int index = row_indices.indexWhere((e) => e > col);
        indices.insert(indptr[row] + index, col);
        indptr = indptr.map((e) => e >= index ? e + 1 : e).toList();
      }
    }
  }

  SparceVector<T> row(int index) {
    List<int> row_indices = indices.sublist(indptr[index], indptr[index + 1]);
    List<T> row_values = data.sublist(indptr[index], indptr[index + 1]);
    return SparceVector.sparce(row_values, row_indices, colLenght);
  }


}

// class CSCMatrixData<T extends num> extends MatrixData<T> {
//
//   List<T> _csc_values = [];
//   List<int> indices = [];
//   List<int> indptr = [];
//
//   CSCMatrixData(this.values, this.indices, this.indptr);
//
// }
//
// class COOMatrixData<T extends num> extends MatrixData<T> {
//
//   List<T> _coo_values = [];
//   List<int> row = [];
//   List<int> col = [];
//
//   COOMatrixData(this.values, this.row, this.col);
//
// }
//
// class UTMMatrixData<T extends num> extends MatrixData<T> {
//
//   List<T> _utm_values = [];
//   List<int> row = [];
//   List<int> col = [];
//
//   UTMMatrixData(this.values, this.row, this.col);
//
// }

/// might implement other matrices in the future


class MatrixVectorRowIterator<T extends num> implements Iterator<Vector<T>> {

  Matrix<T> _matrix; // just so I dont need to unwrap the matrix if its sparse
  int _currentIndex = -1;

  MatrixVectorRowIterator(this._matrix);

  @override
  Vector<T> get current => _matrix.row(_currentIndex);

  @override
  bool moveNext() {
    if (_currentIndex < _matrix.shape[0] - 1) {
      _currentIndex++;
      return true;
    }
    return false;
  }
}

class MatrixVectorColIterator<T extends num> implements Iterator<Vector<T>> {

  Matrix<T> _matrix; // just so I dont need to unwrap the matrix if its sparse
  int _currentIndex = -1;

  MatrixVectorColIterator(this._matrix);

  @override
  Vector<T> get current => _matrix.column(_currentIndex);

  @override
  bool moveNext() {
    if (_currentIndex < _matrix.shape[1] - 1) {
      _currentIndex++;
      return true;
    }
    return false;
  }
}

class MatrixSparceVectorRowIterator<T extends num> extends MatrixVectorRowIterator {
  MatrixSparceVectorRowIterator(super.matrix);

}







