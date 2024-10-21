


class PositionalIndex {

  String word;

  int frequency;

  List<List<int>> positions;

  PositionalIndex(this.word): frequency = 0, positions = [];

  void addDocumentPositions(List<int> docPositions) {
    frequency+=docPositions.length;
    positions.add(docPositions);
  }

  void addDocumentPosition(int documentIndex, int position) {
    frequency++;
    positions[documentIndex].add(position);
  }

  void removeDocument(int documentIndex) {
    frequency-=positions[documentIndex].length;
    positions.removeAt(documentIndex);
  }




}