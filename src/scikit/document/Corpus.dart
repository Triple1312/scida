
import 'dart:convert';

import 'Document.dart';


abstract class Corpus {

    addDoc(Document doc);

    removeDoc(Document doc);

    removeDocAt(int index);

    Document getDocAt(int index);

    Document? getDoc(String name);

    Corpus();

    factory Corpus.docs(List<Document> docs) => DefaultCorpus.docs(docs);

    factory Corpus.empty() => DefaultCorpus.empty();

    factory Corpus.lazy() => LazyCorpus.new();

    factory Corpus.lazy_folder(String folderpath) => LazyCorpus.folder(folderpath);

}



class DefaultCorpus extends Corpus {

  List<Document> docs = new List<Document>.empty(growable: true);

  addDoc(Document doc) {
    docs.add(doc);
  }

  removeDoc(Document doc) {
    docs.remove(doc);
  }

  removeDocAt(int index) {
    docs.removeAt(index);
  }

  Document getDocAt(int index) {
    return docs[index];
  }

  Document? getDoc(String name) {
    for (Document doc in docs) {
      if (doc.filename == name) {
        return doc;
      }
    }
    return null;
  }

  DefaultCorpus.docs(this.docs);

  DefaultCorpus.empty();


}



class LazyCorpus extends Corpus{
  @override
  addDoc(Document doc) {
    // TODO: implement addDoc
    throw UnimplementedError();
  }

  @override
  Document? getDoc(String name) {
    // TODO: implement getDoc
    throw UnimplementedError();
  }

  @override
  Document getDocAt(int index) {
    // TODO: implement getDocAt
    throw UnimplementedError();
  }

  @override
  removeDoc(Document doc) {
    // TODO: implement removeDoc
    throw UnimplementedError();
  }

  @override
  removeDocAt(int index) {
    // TODO: implement removeDocAt
    throw UnimplementedError();
  }

  LazyCorpus();

  LazyCorpus.folder(String folderpath) {

  }


}