
import 'dart:collection';
import 'dart:math';
import 'Vectorizer.dart';
import '../utils/stopwords.dart';

class TfIdfVectorizer extends Vectorizer {
  String _tfType;
  String _idfType;
  String _normType;
  int docCount = 0;
  bool _stopwords;

  // tested tftype: n, t // idftype: t // normtype: n, c
  TfIdfVectorizer({String tfType = 'n', String idfType = 't', String normType = 'c', String stopwords = ''}) : _normType = normType, _idfType = idfType, _tfType = tfType, _stopwords = stopwords == 'english';

  double _calculateTF(double rawTF, double maxTF, int docLength) {
    switch (_tfType) {
      case 'n': return rawTF;
      case 'l': return 1 + log(rawTF);
      case 'a': return 0.5 + (0.5 * rawTF / maxTF);
      case 'b': return rawTF > 0 ? 1.0 : 0.0;
      case 'L': return (1 + log(rawTF)) / (1 + log(docLength.toDouble()));
      default: return rawTF;
    }
  }

  double _calculateIDF(int docFreq) {
    switch (_idfType) {
      case 'n': return 1.0;
      case 't': return log((docCount+1) / (docFreq + 1)) +1;
      case 'tl': return log(docCount / docFreq.toDouble()) + 1;
      case 'p': return log((docCount - docFreq) / docFreq.toDouble()) + 1;
      default: return log(docCount / docFreq.toDouble()) + 1;
    }
  }

  Map<String, double> _normalizeVector(Map<String, double> vector) {
    if (_normType == 'n') return vector;  // No normalization
    if (_normType == 'l2' || _normType == 'c') {
      double norm = sqrt(vector.values.map((x) => x * x).reduce((a, b) => a + b));
      return vector.map((term, value) => MapEntry(term, value / norm));
    }
    return vector;
  }


  // different than other fit methods, resets vocab and doc count
  @override
  void fit(List<String> documents, {bool sorted = false} ) { // should not be called directly but possible if necessary // todo
    docCount = documents.length;
    var uniqueTerms = Set<String>();
    for (var i = 0; i < documents.length; i++) {
      List<String> terms = documents[i].split(" ");
      if (_stopwords) {
        terms = terms.where((term) => !ENGLISH_STOP_WORDS.contains(term)).toList();
      }
      uniqueTerms.addAll(terms);
    }
    this.vocab = uniqueTerms.toList();
  }



  @override
  List<List<double>> transform(List<String> documents) {
    // TODO: implement transform
    throw UnimplementedError();
  }

  @override
  List<List<double>> fit_transform(List<String> documents, {bool sorted = false}) {
    docCount = documents.length;
    var termDocs = HashMap<String, Set<int>>();
    HashMap<String, double> idfScores = HashMap<String, double>();


    var uniqueTerms = Set<String>(); // needed ??

    for (var i = 0; i < documents.length; i++) {
      List<String> terms = documents[i].split(" ");
      if (_stopwords) {
        terms = terms.where((term) => !ENGLISH_STOP_WORDS.contains(term)).toList();
      }
      uniqueTerms = Set<String>.from(terms);
      uniqueTerms.forEach((term) {
        (termDocs[term] ??= {}).add(i);
      });
    }
    termDocs.forEach((term, docs) {
      idfScores[term] = _calculateIDF(docs.length);
    });

    for (var i = 0; i < documents.length; i++) {
      List<String> terms = documents[i].split(" ");
      if (_stopwords) {
        terms = terms.where((term) => !ENGLISH_STOP_WORDS.contains(term)).toList();
      }
      uniqueTerms.addAll(terms);
    }

    vocab = uniqueTerms.toList(); // this is the order
    if (sorted) {
      vocab.sort();
    }

    return documents.map((doc) {
      // Split the document into terms and optionally filter out stop words.
      List<String> rawTerms = doc.split(" ");
      List<String> terms = _stopwords ? rawTerms.where((term) => !ENGLISH_STOP_WORDS.contains(term)).toList() : rawTerms;

      // Calculate term frequencies in one pass.
      Map<String, int> termFreqs = {};
      for (var term in terms) {
        termFreqs[term] = (termFreqs[term] ?? 0) + 1;
      }

      // Determine the maximum term frequency for normalization.
      int maxTF = termFreqs.values.reduce(max);

      // Create the TF-IDF vector for the document.
      Map<String, double> tfidfVector = termFreqs.map((term, count) {
        double tf = _calculateTF(count.toDouble(), terms.length.toDouble(), maxTF);
        return MapEntry(term, tf * (idfScores[term] ?? 0.0));
      });

      // Normalize the TF-IDF vector and convert it into a list using the vocabulary.
      double norm = sqrt(tfidfVector.values.map((x) => x * x).reduce((a, b) => a + b));
      return vocab.map((word) => (tfidfVector[word] ?? 0.0) / norm).toList();
    }).toList();


    // what code was faster? todo test

    // var eek =  documents.map((doc) {
    //   List<String> terms = doc.split(" ");
    //   if (_stopwords) {
    //     terms = terms.where((term) => !ENGLISH_STOP_WORDS.contains(term)).toList();
    //   }
    //   var maxTF = terms.map((term) => terms.where((t) => t == term).length).reduce(max);
    //   var tfidfVector = {
    //     for (var term in terms) term: _calculateTF(terms.where((t) => t == term).length.toDouble(), terms.length.toDouble(), maxTF) * idfScores[term]!
    //   };
    //   return _normalizeVector(tfidfVector);
    // });
    //
    // return eek.map((doc) => vocab.map((word) => doc[word] ?? 0.0).toList()).toList();
  }

  translate(int index) {
    return vocab[index];
  }

  set tfType(String value) {
    if (value != 'n' && value != 'l' && value != 'a' && value != 'b' && value != 'L') {
      throw Exception('Invalid value for tfType: $value');
    }
    else {
      _tfType = value;
    }
  }

  set idfType(String value) {
    if (value != 'n' && value != 't' && value != 'p') {
      throw Exception('Invalid value for idfType: $value');
    }
    else {
      _idfType = value;
    }
  }

  set normType(String value) {
    if (value != 'n' && value != 'l1' && value != 'l2') {
      throw Exception('Invalid value for normType: $value');
    }
    else {
      _normType = value;
    }
  }

  String get tfType => _tfType;
  String get idfType => _idfType;
  String get normType => _normType;



}