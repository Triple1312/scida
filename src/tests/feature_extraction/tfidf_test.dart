


import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import '../../scikit/feature_extraction/TfidfVectorizer.dart';

void main() {
  group("tfidf test", () {
    test("3doc", () {
     var docs = ["the quick brown fox", "brown fox jumps over the lazy dog", "the quick dog and the fox"];
     var tfidf = TfIdfVectorizer();
     var x = tfidf.fit_transform(docs, sorted: true);
     expect(x, [
       [ 0.0, 0.5584778353707552, 0.0, 0.4337078595086741, 0.0, 0.0, 0.0, 0.5584778353707552, 0.4337078595086741],
       [0.0, 0.34517851538731575, 0.34517851538731575, 0.2680619096684997, 0.45386826657073503, 0.45386826657073503, 0.45386826657073503, 0.0, 0.2680619096684997],
       [0.506308939707281, 0.0, 0.3850609989897761, 0.2990342159975946, 0.0, 0.0, 0.0, 0.3850609989897761, 0.5980684319951892]
     ]);
    });
  });
}
