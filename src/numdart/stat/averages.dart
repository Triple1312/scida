

import 'dart:math';

num  average(List<num> data) {
  return data.reduce((a, b) => a + b) / data.length;
}

num mean(List<num> data) => average(data);

num  weightedAverage(List<num> data, List<num> weights) {
  if (data.length != weights.length) {
    throw ArgumentError('data and weights must have the same length');
  }
  num sum = 0;
  num sumWeights = 0;
  for (int i = 0; i < data.length; i++) {
    sum += data[i] * weights[i];
    sumWeights += weights[i];
  }
  return sum / sumWeights;
}

num  harmonicMean(List<num> data) {
  num sum = 0;
  for (int i = 0; i < data.length; i++) {
    sum += 1 / data[i];
  }
  return data.length / sum;
}

num  geometricMean(List<num> data) {
  num product = 1;
  for (int i = 0; i < data.length; i++) {
    product *= data[i];
  }
  return pow(product, 1 / data.length);
}

num  variance(List<num> data) {
  num mean = average(data);
  num sum = 0;
  for (int i = 0; i < data.length; i++) {
    sum += (data[i] - mean) * (data[i] - mean);
  }
  return sum / data.length;
}

num  standardDeviation(List<num> data) {
  return sqrt(variance(data));
}

num  median(List<num> data) {
  data.sort();
  if (data.length % 2 == 0) {
    return (data[data.length ~/ 2 - 1] + data[data.length ~/ 2]) / 2;
  } else {
    return data[data.length ~/ 2];
  }
}

num  mode(List<num> data) {
  Map<num, int> frequency = {};
  for (int i = 0; i < data.length; i++) {
    frequency[data[i]] = (frequency[data[i]] ?? 0) + 1;
  }
  int maxFrequency = 0;
  num mode = 0;
  frequency.forEach((key, value) {
    if (value > maxFrequency) {
      maxFrequency = value;
      mode = key;
    }
  });
  return mode;
}

num  skewness(List<num> data) {
  num mean = average(data);
  num sum = 0;
  for (int i = 0; i < data.length; i++) {
    sum += pow(data[i] - mean, 3);
  }
  return sum / (data.length * pow(standardDeviation(data), 3));
}

num  kurtosis(List<num> data) {
  num mean = average(data);
  num sum = 0;
  for (int i = 0; i < data.length; i++) {
    sum += pow(data[i] - mean, 4);
  }
  return sum / (data.length * pow(standardDeviation(data), 4));
}

num  covariance(List<num> data1, List<num> data2) {
  if (data1.length != data2.length) {
    throw ArgumentError('data1 and data2 must have the same length');
  }
  num mean1 = average(data1);
  num mean2 = average(data2);
  num sum = 0;
  for (int i = 0; i < data1.length; i++) {
    sum += (data1[i] - mean1) * (data2[i] - mean2);
  }
  return sum / data1.length;
}

num  correlation(List<num> data1, List<num> data2) {
  return covariance(data1, data2) / (standardDeviation(data1) * standardDeviation(data2));
}

num  percentile(List<num> data, num p) {
  data.sort();
  return data[((data.length - 1) * p).round()];
}

num  quantile(List<num> data, num q) {
  data.sort();
  int n = data.length;
  if (q == 0) {
    return data[0];
  } else {
    return data[(n * q).round()];
  }
}

num  iqr(List<num> data) {
  data.sort();
  return quantile(data, 0.75) - quantile(data, 0.25);
}

num  mad(List<num> data) {
  num medianValue = median(data);
  List<num> absoluteDeviations = [];
  for (int i = 0; i < data.length; i++) {
    absoluteDeviations.add((data[i] - medianValue).abs());
  }
  return median(absoluteDeviations);
}

num  zScore(num x, num mean, num standardDeviation) {
  return (x - mean) / standardDeviation;
}




