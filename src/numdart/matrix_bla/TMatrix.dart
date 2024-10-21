

import '../data/NData.dart';
import '../data/NNDarray.dart';
import '../vector/Vector.dart';
import 'NMatrixIteraotors.dart';

class TMatrix<T> extends NNDarray<T> {
  late NData<T> data;

  TMatrix(this.data);


}