

import 'package:test/test.dart';
import '../../numdart/new_data/Matrix.dart';
import '../../numdart/new_data/Vector.dart';

void main() {

  group("Constructor tests", () {
    // test("Throw size error on NDarray wrong shape",() {
    //   NDarray<num> nda = NDarray<num>.array(values: [0, 1, 2, 3, 4, 5, 6, 7], shape: [2, 2, 2]);
    //   expect(NMatrix.fromNDarray(nda),throwsException);
    // });
    // test("Throw size error on NMatrix wrong shape length with zeros",() {
    //   expect(NMatrix.zeros([2,2,2]),throwsException);
    //   expect(NMatrix.zeros([2]),throwsException);
    // });
    test("Zeros constructor 1", () {
      Matrix matrix = Matrix.zeroes([2,2]);
      expect(matrix.shape, [2,2]);
      expect(matrix.flat, [0, 0, 0, 0]);
    });
    test("Zeros constructor 2", () {
      Matrix matrix = Matrix.zeroes([3,10]);
      expect(matrix.shape, [3,10]);
      expect(matrix.flat, List.generate(30, (i) => 0));
    });
    test("Constructor Identity", () {
      Matrix matrix = Matrix.identity(3);
      expect(matrix.flat, [1, 0, 0, 0, 1, 0, 0, 0, 1]);
    });

    test("Constructor Default", () {
      Matrix m = Matrix(values: [[1, 2, 3], [4, 5, 6], [7, 8, 9]]);
      expect(m.flat, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
    });
  });

  group("getter tests", () {
    List<num> values = List<num>.generate(9, (i) => i+1);
    Matrix matrix = Matrix.flat(values, 3, 3);
    test("get diagonal", () {
      expect(matrix.diagonal, [1, 5, 9]);
    });
    test("diagonal sum ", () {
      expect(matrix.diagonalSum, 15);
    });
    test("diagonal product", () {
      expect(matrix.diagonalProduct, 45);
    });
    test("toString", () {
      // expect(matrix.toString(),"[1, 2, 3]\n[4, 5, 6]\n[7, 8, 9]");
    });
  });

  group("Decomposition tests", () {
    var y = Matrix.flat([1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3).dot(Matrix.flat([1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3));
    test("QR decomposition 1",(){
      var matrix2 = Matrix.flat([12, -51, 4, 6, 167, -68, -4, 24, -41], 3, 3);
      var qr = matrix2.qrDecomposition();
      expect(qr.$1.flat.map((num e) => (e * 1000).floor() ).toList(), [6/7, -69/175, -58/175, 3/7, 158/175, 6/175, -2/7, 6/35, -33/35].map((num e) => (e * 1000).floor() ).toList());
      expect(qr.$2.flat.map(  (num e) => (e * 1000).round()).toList(), [14, 21, -14, 0, 175, -70, 0, 0, 35].map((num e) => (e * 1000).round() ).toList());
    });

    test("LU decomposition 1", () {
      var matrix3 = Matrix.flat([4, 3, 6, 3], 2, 2);
      var lu = matrix3.luDecomposition();
      expect(lu.$1.flat, [1, 0, 1.5, 1]);
      expect(lu.$2.flat, [4, 3, 0, -1.5]);
    });
  });

  group("eek", () {
    test("det", (){
      var matrix = Matrix.flat([4, 1, 0, 2], 2, 2);
      expect(matrix.det, 8);
    });
    test("eigenvalues", (){
      var matrix = Matrix.flat([4, 1, 2, 3], 2, 2);
      expect(matrix.eigenvalues().map((num e) => (e*10000).round()).toList(), [(5 *10000).round(), (2 *10000).round()]);
    });
    test("backward Substitution", () {
      var mmatrix = Matrix.flat([1, 2, 3, 0, 2, 5, 0, 0, 3], 3, 3);
      var yy = Vector([9, 8, 6]);
      expect(mmatrix.backwardSubstitution(yy).flat, [5, -1, 2]);
    });
    test("forward Substitution", () {
      var matrix = Matrix.flat([1, 0, 0, 2, 3, 0, 4, 5, 6], 3, 3);
      var y = Vector([1, 2, 3]);
      expect(matrix.forwardSubstitution(y).flat, [1.0, 0.0, -0.16666666666666666]);
    });
    test("inverse", () {
      var invmatrix = Matrix.flat([4, 3, 3, 2], 2, 2);
      expect(invmatrix.inverse!.flat, [-2, 3, 3, -4]);
    });
  });

  group("test space", () {
    var matrix = Matrix.flat([1, 2, 3, 4, 5, 6], 2, 3);
    test("get", () {
      expect(matrix.get([0, 1]), 2);
    });
    test("shape", () {
      expect(matrix.shape, [2, 3]);
    });
  });

  group("test dot", () {
    var matrix = Matrix.flat([1, 2, 3, 4, 5, 6], 2, 3);
    var matrix2 = Matrix.flat([1, 2, 3, 4, 5, 6], 3, 2);
    test("dot", () {
      expect(matrix.dot(matrix2).flat, [9, 12, 15, 19, 26, 33, 29, 40, 51]);
    });
  });
}