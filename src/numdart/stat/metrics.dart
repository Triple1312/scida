

num r2Score(List<num> observed, List<num> predicted) {
  if (observed.length != predicted.length) {
    throw ArgumentError('observed and predicted must have the same length');
  }

  double meanObserved = observed.reduce((a, b) => a + b) / observed.length;
  double totalSumOfSquares = observed.fold(0, (sum, val) => sum + (val - meanObserved) * (val - meanObserved));
  double residualSumOfSquares = 0;

  for (int i = 0; i < observed.length; i++) {
    residualSumOfSquares += (observed[i] - predicted[i]) * (observed[i] - predicted[i]);
  }

  double rSquared = 1 - (residualSumOfSquares / totalSumOfSquares);
  return rSquared;
}

num mse();

num rmse();

num mae();

num mape();

num evs();

num accuracy_score(List<num> observed, List<num> predicted, {bool normalize = true, List<num> sample_weight = const []}) {
  

}