import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import '../../scikit/feature_extraction/CountVectorizer.dart';

void main() {
  group("count vectorizer test", () {
    test("3doc", () {
      var docs = ["the quick brown fox", "brown fox jumps over the lazy dog", "the quick dog and the fox"];
      var count_vec = Countvectorizer();
      var x = count_vec.fit_transform(docs, sorted: true);
      expect(x, [
        [0.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 1.0],
        [0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 1.0],
        [1.0, 0.0, 1.0, 1.0, 0.0, 0.0, 0.0, 1.0, 2.0]
      ]);
    });
  });
}
