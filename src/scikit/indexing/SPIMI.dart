
import 'dart:io';

import '../document/Document.dart';
import 'InvertedIndexer.dart';

class SPIMI {

  // todo check memory usage
  SPIMI fit(String folderpath, int maxSizeBytes) {
    final directory = Directory(folderpath);
    if (directory.existsSync()) {
      List<FileSystemEntity> files = directory.listSync(); // todo can also be other dirs ?
      int currentsize = 0;
      List<File> currentfiles = [];
      for (int i = 0; i < files.length; i++) {
        FileSystemEntity file = files[i];
        if (file is File) {
          int length = file.lengthSync();
          if (currentsize + length > maxSizeBytes) {
            List<Document> openedfiles = currentfiles.fold([], (a, f) => a + [new Document(f.path, f.readAsStringSync())]);
            InvertedIndexer indexer = new InvertedIndexer()..fit(openedfiles, fileIndexStart: i);

          }
          else if (i == files.length - 1) {
            currentfiles.add(file);
            currentsize += length;
          }
          else {
            currentfiles.add(file);
            currentsize += length;
          }
        }
      }
    }


  }

  void _saveIndexer(InvertedIndexer indexer, String folderPath) {
    File file = File(folderPath + "/indexer.json");
    file.writeAsStringSync(indexer.toJson());

  }

  // void fitAsync(String folderPath, int maxmemMB) async {
  //
  // }




}