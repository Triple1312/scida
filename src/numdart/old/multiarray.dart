



// todo should also work with doubles

// dynamic dot(dynamic a, dynamic b) {
//   if (a is List<int> && b is List<int>) {
//     return vdot(a, b);
//   }
//   else if (a is List<List<int>> && b is List<int>) {
//     return mvdot(mat: a, vec: b);
//   }
//   else if (a is List<int> && b is List<List<int>>) {
//     return mvdot(mat: b, vec: a);
//   }
//   else if (a is List<List<int>> && b is List<List<int>>) {
//     return mdot(a, b);
//   }
//   else {
//     throw Exception('Invalid types for dot product');
//   }
// }

int vdot(List<int> a, List<int> b) {
  if (a.length != b.length) {
    throw Exception('Length of a and b must be equal for dot product');
  }
  return a.fold(0, (prev, element) => prev + element * b[a.indexOf(element)]);
}

List<int> mvdot({required List<List<int>> mat, required List<int> vec}) {
  if (mat[0].length != vec.length) {
    throw Exception('Length of matrix and vector must be equal for dot product');
  }
  return mat.map((e) => vdot(e, vec)).toList();
}

List<List<int>> mdot(List<List<int>> a, List<List<int>> b) {
  if (a.length != b[0].length) {
    throw Exception("Length of a's rows and b's columns must be equal for dot product");
  }
  return a.map((e) => mvdot(mat: b, vec: e)).toList();
}