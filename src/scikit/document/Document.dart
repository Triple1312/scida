


import 'dart:io';

abstract class Document {

  abstract String contents;

  abstract String filename;

  factory Document(String name, String contents) =>
      DefaultDocument(name, contents);

  factory Document.open(String filepath) =>
      DefaultDocument.open(filepath);








}


class DefaultDocument implements Document {

  DefaultDocument(this.filename, this.contents);

  @override
  late String contents;

  @override
  late String filename;


  DefaultDocument.open(String filepath) {
    File file = new File(filepath);
    file.open();
    filename = file.path.split("/").last;
    contents = file.readAsStringSync();

  }

  

}


class ClosedDocument implements Document {

  File file;

  @override
  String get contents => file.readAsStringSync();

  @override
  String get filename => file.path.split("/").last;

  ClosedDocument(String filepath) : file = new File(filepath);

  @override
  set contents(String _contents) {
    file.writeAsStringSync(_contents);
  }

  @override
  set filename(String _filename) {
    file.rename(_filename);
  }

}