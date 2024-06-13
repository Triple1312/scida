

// import 'OMatrix.dart';
//
// ///
// /// These classes are not required to be used but could save a lot of memory
//
// ///
// /// Upper Triangular Matrix
// class UTM<T extends num> extends Matrix<T> { // todo at the moment is same as normal matrix // should change
//   UTM({required super.values});
//
//   UTM.zeros(List<int> shape): super.zeros(shape) {
//     if (shape.length != 2) {
//       throw Exception("Matrix must be 2D");
//     }
//   }
// }
//
//
//
// ///
// /// Lower Triangular Matrix
// class LTM<T extends num> extends Matrix<T> { // todo make more efficient
//   LTM({required super.values});
//
//   LTM.zeros(List<int> shape): super.zeros(shape) {
//     if (shape.length != 2) {
//       throw Exception("Matrix must be 2D");
//     }
//   }
//
//   LTM.identity(int size) : super.identity(size);
// }