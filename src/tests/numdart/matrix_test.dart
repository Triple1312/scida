//
//
// import 'package:test/test.dart';
//
// import '../../numpy/NDarray.dart';
// import '../../numpy/old/OMatrix.dart';
//
// void main() {
//
//   group("Constructor tests", () {
//     // test("Throw size error on NDarray wrong shape",() {
//     //   NDarray<num> nda = NDarray<num>.array(values: [0, 1, 2, 3, 4, 5, 6, 7], shape: [2, 2, 2]);
//     //   expect(Matrix.fromNDarray(nda),throwsException);
//     // });
//     // test("Throw size error on Matrix wrong shape length with zeros",() {
//     //   expect(Matrix<num>.zeros([2,2,2]),throwsException);
//     //   expect(Matrix<num>.zeros([2]),throwsException);
//     // });
//     test("Zeros constructor 1", () {
//       OMatrix matrix = OMatrix<num>.zeros([2,2]);
//       expect(matrix.shape, [2,2]);
//       expect(matrix.values, [0, 0, 0, 0]);
//     });
//     test("Zeros constructor 2", () {
//       OMatrix<num> matrix = OMatrix<num>.zeros([3,10]);
//       expect(matrix.shape, [3,10]);
//       expect(matrix.values, List.generate(30, (i) => 0));
//     });
//     test("Constructor Identity", () {
//       OMatrix<num> matrix = OMatrix<num>.identity(3);
//       expect(matrix.values, [1, 0, 0, 0, 1, 0, 0, 0, 1]);
//     });
//   });
//
//   group("getter tests", () {
//     List<num> values = List<num>.generate(9, (i) => i+1);
//     OMatrix<num> matrix = OMatrix<num>( values, [3,3]);
//     test("get diagonal", () {
//       expect(matrix.diagonal.values, [1, 5, 9]);
//     });
//     test("diagonal sum ", () {
//       expect(matrix.diagonal_sum, 15);
//     });
//     test("diagonal product", () {
//       expect(matrix.diagonal_product, 45);
//     });
//     test("toString", () {
//       expect(matrix.toString(),"[1, 2, 3]\n[4, 5, 6]\n[7, 8, 9]");
//     });
//   });
//
//   group("Decomposition tests", () {
//     var y = OMatrix<num>([1, 2, 3, 4, 5, 6, 7, 8, 9], [3, 3]).dot(OMatrix<num>([1, 2, 3, 4, 5, 6, 7, 8, 9], [3, 3]));
//     test("QR decomposition 1",(){
//       var matrix2 = OMatrix<num>([12, -51, 4, 6, 167, -68, -4, 24, -41], [3, 3]);
//       var qr = matrix2.qrDecomposition();
//       expect(qr.$1.values.map((num e) => (e * 1000).floor() ).toList(), [6/7, -69/175, -58/175, 3/7, 158/175, 6/175, -2/7, 6/35, -33/35].map((num e) => (e * 1000).floor() ).toList());
//       expect(qr.$2.values.map(  (num e) => (e * 1000).round()).toList(), [14, 21, -14, 0, 175, -70, 0, 0, 35].map((num e) => (e * 1000).round() ).toList());
//     });
//
//     test("LU decomposition 1", () {
//       var matrix3 = OMatrix<num>([4, 3, 6, 3], [2, 2]);
//       var lu = matrix3.luDecomposition();
//       expect(lu.$1.values, [1, 0, 1.5, 1]);
//       expect(lu.$2.values, [4, 3, 0, -1.5]);
//     });
//   });
// }