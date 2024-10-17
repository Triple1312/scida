
import 'dart:math';


typedef NumericDistanceFnc = num Function(List<num>, List<num>);


num manhattanDistance(List<num> a, List<num> b) {
  if (a.length != b.length) {
    throw Exception('Length of a and b must be equal for manhattan distance');
  }
  return a.fold(0, (prev, element) => prev + (element - b[a.indexOf(element)]).abs());
}

num euclideanDistance(List<num> a, List<num> b) {
  if (a.length != b.length) {
    throw Exception('Length of a and b must be equal for euclidean distance');
  }
  return sqrt(a.fold(0, (prev, element) => prev + pow(element - b[a.indexOf(element)], 2)));
}

num hammingDistance(List<num> a, List<num> b) {
  if (a.length != b.length) {
    throw Exception('Length of a and b must be equal for hamming distance');
  }
  return a.fold(0, (prev, element) => prev + (element != b[a.indexOf(element)] ? 1 : 0));
}

num cosineDistance(List<num> a, List<num> b) {
  if (a.length != b.length) {
    throw Exception('Length of a and b must be equal for cosine distance');
  }
  // is the toInt needed ?
  return 1 - (a.fold(0, (prev, element) => prev + (element * b[a.indexOf(element)]).toInt()) / (sqrt(a.fold(0, (prev, element) => prev + pow(element, 2))) * sqrt(b.fold(0, (prev, element) => prev + pow(element, 2)))));
}

num chebyshevDistance(List<num> a, List<num> b) {
  if (a.length != b.length) {
    throw Exception('Length of a and b must be equal for chebyshev distance');
  }
  return a.fold(0, (prev, element) => max(prev, (element - b[a.indexOf(element)]).abs()));
}

num minkowskiDistance(List<num> a, List<num> b, num p) {
  if (a.length != b.length) {
    throw Exception('Length of a and b must be equal for minkowski distance');
  }
  return pow(a.fold(0, (prev, element) => prev + pow((element - b[a.indexOf(element)]).abs(), p)), 1 / p);
}



typedef FeatureDistanceFnc = num Function(List<dynamic>, List<dynamic>);

// todo idk what this is
num jaccardDistance(List<num> a, List<num> b) {
  if (a.length != b.length) {
    throw Exception('Length of a and b must be equal for jaccard distance');
  }
  return 1 - a.fold(0, (prev, element) => prev + (element == b[a.indexOf(element)] ? 1 : 0)) / a.fold(0, (prev, element) => prev + (element != b[a.indexOf(element)] ? 1 : 0));
}