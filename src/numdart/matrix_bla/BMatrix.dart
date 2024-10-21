


import '../data/NDSparce.dart';
import 'Matrix.dart';

class BMatrix extends Matrix {

  BMatrix(SparceBinMatrix data) : super(data);

  BMatrix.empty() : super(SparceBinMatrix(0,0));




}