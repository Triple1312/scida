

import 'package:test/test.dart';

import '../../numpy/data/NData.dart';
import '../../numpy/matrix/Matrix.dart';
import '../../numpy/vector/Vector.dart';

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
      expect(matrix.data.flat, [0, 0, 0, 0]);
    });
    test("Zeros constructor 2", () {
      Matrix matrix = Matrix.zeroes([3,10]);
      expect(matrix.shape, [3,10]);
      expect(matrix.data.flat, List.generate(30, (i) => 0));
    });
    test("Constructor Identity", () {
      Matrix matrix = Matrix.identity(3);
      expect(matrix.data.flat, [1, 0, 0, 0, 1, 0, 0, 0, 1]);
    });
  });

  group("getter tests", () {
    List<num> values = List<num>.generate(9, (i) => i+1);
    Matrix matrix = Matrix( NumNList(values, [3,3]));
    test("get diagonal", () {
      expect(matrix.diagonal.data.flat, [1, 5, 9]);
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
    var y = Matrix(NumNList([1, 2, 3, 4, 5, 6, 7, 8, 9], [3, 3])).dot(Matrix(NumNList([1, 2, 3, 4, 5, 6, 7, 8, 9], [3, 3])));
    test("QR decomposition 1",(){
      var matrix2 = Matrix(NumNList([12, -51, 4, 6, 167, -68, -4, 24, -41], [3, 3]));
      var qr = matrix2.qrDecomposition();
      expect(qr.$1.data.flat.map((num e) => (e * 1000).floor() ).toList(), [6/7, -69/175, -58/175, 3/7, 158/175, 6/175, -2/7, 6/35, -33/35].map((num e) => (e * 1000).floor() ).toList());
      expect(qr.$2.data.flat.map(  (num e) => (e * 1000).round()).toList(), [14, 21, -14, 0, 175, -70, 0, 0, 35].map((num e) => (e * 1000).round() ).toList());
    });

    test("LU decomposition 1", () {
      var matrix3 = Matrix(NumNList([4, 3, 6, 3], [2, 2]));
      var lu = matrix3.luDecomposition();
      expect(lu.$1.data.flat, [1, 0, 1.5, 1]);
      expect(lu.$2.data.flat, [4, 3, 0, -1.5]);
    });
  });
}