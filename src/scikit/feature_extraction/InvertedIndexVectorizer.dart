
//
// import 'dart:collection';
//
// import 'Vectorizer.dart';
//
// class InvertedIndexVectorizer extends Vectorizer {
//
//   HashMap<String, List<int>> invertedIndex = HashMap<String, List<int>>();
//
//   int docCount = 0;
//
//   @override
//   void fit(List<String> documents, {bool sorted = false}) {
//     for (int i = 0; i < documents.length; i++) {
//       List<String> terms = documents[i].split(" ");
//       for (String term in terms) {
//         if (add_to_vocab(term)) {
//           invertedIndex[term] = [i];
//         }
//         else {
//           invertedIndex[term]!.add(i);
//         }
//       }
//     }
//   }
//
//   @override
//   List<List<double>> fit_transform(List<String> documents, {bool sorted = false}) {
//     // TODO: implement fit_transform
//     throw UnimplementedError();
//   }
//
//   @override
//   List<List<double>> transform(List<String> documents) {
//     // TODO: implement transform
//     throw UnimplementedError();
//   }
//
//
//
//
// }