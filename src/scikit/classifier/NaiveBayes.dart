

import 'package:meta/meta.dart';

import '../../numdart/matrix/Matrix.dart';
import '../../pandas/dataframe/DDataFrame.dart';
import 'helpers/TableLink.dart';

abstract class NaiveBayes {

  // sklearn methods

  void predict_joint_log_proba(List<List<double>> X) {
    throw UnimplementedError();
  }

  void predict_log_proba(List<List<double>> X) {
    throw UnimplementedError();
  }

  void predict(List<List<double>> X) {
    throw UnimplementedError();
  }

  void predict_proba(List<List<double>> X) {
    throw UnimplementedError();
  }

}


class GaussianNB extends NaiveBayes {

  void partial_fit(List<List<double>> X, List<double> y, List<double> classes) {
    throw UnimplementedError();
  }


}

class DiscreteNB extends NaiveBayes {

  late TableLink<int> _table;

  DiscreteNB.fit(DataFrame df) {
    
  }





}