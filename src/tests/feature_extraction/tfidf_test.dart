


import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import '../../numdart/new_data/Matrix.dart';
import '../../scikit/document/Corpus.dart';
import '../../scikit/feature_extraction/TfidfVectorizer.dart';

void main() {
  group("tfidf test", () {
    var docs = ["the quick brown fox", "brown fox jumps over the lazy dog", "the quick dog and the fox"];
    var tfidf = TfIdfVectorizer();
    var x = tfidf.ffff(docs);
    test("fit transform", () {
     expect(x, [
       [
         0.4337078595086741,
         0.5584778353707552,
         0.5584778353707552,
         0.4337078595086741,
         0,
         0,
         0,
         0,
         0
       ],
       [
         0.2680619096684997,
         0,
         0.34517851538731575,
         0.2680619096684997,
         0.45386826657073503,
         0.45386826657073503,
         0.45386826657073503,
         0.34517851538731575,
         0
       ],
       [
         0.5980684319951892,
         0.3850609989897761,
         0,
         0.2990342159975946,
         0,
         0,
         0,
         0.3850609989897761,
         0.506308939707281
       ]
     ]);
    });
    test("transform", () {
      Matrix<num> y = tfidf.transform(["the quick dog", "the dog and the fox"]);
      expect(y, [[
        0.48133416873660545,
        0.6198053799406072,
        0,
        0,
        0,
        0,
        0,
        0.6198053799406072,
        0
      ],
      [
        0.6480379064629607,
        0,
        0,
        0.32401895323148033,
        0,
        0,
        0,
        0.41723339721076924,
        0.5486117771118657
      ]]);
    });
    test("query simple", () {
      List<String> documents = ["the quick brown fox", "brown fox jumps over the lazy dog", "the quick dog and the fox"];
      String query = "the quick dog";
      TfIdfVectorizer tfidf = TfIdfVectorizer();
      tfidf.ffff(documents);
      List<(int, num)> result = tfidf.query(query, 3);
      expect(result, [(2, 0.7071067811865475), (1, 0.7071067811865475), (4, 0.7071067811865475)]);
    });
    test("test query", () {
      List<String> documents = [
        "The agile brown fox swiftly jumps over a lazy dog",
        "Foxes are quick and often leap over sleeping dogs in forests",
        "A fast fox jumps effortlessly over a dog",
        "The dog barks at the jumping fox but cannot catch it",
        "Quick foxes are known for jumping over things",
        "Dogs often sleep while foxes jump around them",
        "The forest is home to many animals, including foxes and dogs",
        "Foxes jump, leap, and bound over obstacles in their way",
        "Dogs and foxes share the forest habitat, where they often interact",
        "A fox is an agile animal capable of jumping and leaping",
      ];
      String query = "fox jump over dog";
      TfIdfVectorizer tfidf = TfIdfVectorizer();
      tfidf.ffff(documents);
      List<(int, num)> result = tfidf.query(query, 3);
      expect(result, [(2, 0.7071067811865475), (1, 0.7071067811865475), (4, 0.7071067811865475)]);
    });
  });
}
