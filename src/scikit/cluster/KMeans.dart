

import 'dart:math';


import '../../numpy/matrix/Matrix.dart';
import '../../numpy/vector/Vector.dart';
import '../algorithms/distance.dart';

class KMeans {

  int _clusterCount;
  int _maxIter;
  String _algorithm;


  KMeans(this._clusterCount, this._maxIter, {String algorithm = "lloyd"}): _algorithm = algorithm {
    if (_clusterCount <= 0) {
      throw Exception("Number of clusters must be greater than 0");
    }
    if (_maxIter <= 0) {
      throw Exception("Number of iterations must be greater than 0");
    }

  }

  int get n_clusters => _clusterCount;

  int get max_iter => _maxIter;

  List<int> lloyd( Matrix m, int k, {int max_it = 300}) { // todo add early break
    List<Vector> centroids = [m.row(Random().nextInt(m.shape[0]))];
    // selecting initial centroids
    for (int i = 1; i < k; i++) { // yeah no prob
      List<num> min_distances = [];
      for (var  vec in m) {
        num minn = double.infinity;
        for (var centroid in centroids) {
          num dist = euclideanDistance(vec.flat , centroid.flat);
          if (dist < minn) {
            minn = dist;
          }
        }
        min_distances.add(minn);
      }

      num biggest = 0;
      int ind = 0;
      for (int j = 0; j < min_distances.length; j++) {
        if (min_distances[j] > biggest) {
          biggest = min_distances[j];
          ind = j;
        }
      }
      centroids.add(m.row(ind));
    }

    // iterating
    List<int> labels = List.filled(m.shape[0], 0);
    for (int i = 0; i < max_it; i++) {
      // find best centroid for every point
      for (int j = 0; j < labels.length; j++) {
        num minn = double.infinity;
        for (int ci = 0; ci < centroids.length; ci++) {
          num dist = euclideanDistance(m.row(j).flat, centroids[ci].flat);
          if (dist < minn) {
            minn = dist;
            labels[j] = ci;
          }
        }
      }

      // update centroids
      for (int ci = 0; ci < centroids.length; ci++) {
        int count = 0;
        List<Vector> points = [];
        for (int j = 0; j < labels.length; j++) {
          if (labels[j] == ci) {
            count++;
            points.add(m.row(j));
          }
        }
        Vector ave = points.fold(Vector.zeroes(points[0].size), (a, b) => a + b);
        centroids[ci] = ave / count;
      }


    }
    return labels;
  }
}




























