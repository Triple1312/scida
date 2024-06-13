

import '../NDarray.dart';

// maybe just return list ?
// todo works basically not
NDarray diff({required List a, int n=1, int axis=-1, int prepend=0, int append=0}) { // todo prepend and append
  var aa = NDarray(values: a);
  int nd = aa.ndim;
  if (nd == 0) {
    throw Exception('diff requires input that is at least 1-D');
  }
  if (n == 0) {
    return aa;
  }
  // axis = normalize_axis_index(axis, nd); // todo idk
  var combined = [];

  // if prepend ...

  combined.add(aa);

  // if len(combined) > 1 ...

  int dim = aa.shape[axis];
  if (axis==-1) { // i know its the last one ;)
    List lst = aa.flatten();
    for (int l = 0; l < n; l++) { // number of itterations the operation should be done
      List tmplst = [];
      for (int i = 0; i < lst.length ~/ dim; i++) {
        for (int j =0; j < dim-1; j++) {
          tmplst.add(lst[i*dim+j+1] - lst[i*dim+j]);
        }
      }
      lst = tmplst;
    }
    return NDarray(values: lst);
  }
  else {
    // ndim arrays bigger than 1
  }
}