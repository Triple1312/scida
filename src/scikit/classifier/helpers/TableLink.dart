

/// this class is made for remembering how many items link to each other and ho many times

class TableLink<T> {
  List<String> names = [];

  List<List<T>> values = []; // todo pl change

  TableLink(this.names, {required T defaultValue}) {
    for (int i = 0; i < names.length -1 ; i++) {
      values.add(List.filled(names.length - i , defaultValue));
    }
  }


  /// todo doesnt catch if names are not in the list
  T get(String name1, String name2) {
    List<int> indeces = [];
    indeces.add(names.indexOf(name1));
    indeces.add(names.indexOf(name2));
    indeces.sort();
    return values[indeces[0]][indeces[1]];
  }

  void set(String name1, String name2, T value) {
    List<int> indeces = [];
    indeces.add(names.indexOf(name1));
    indeces.add(names.indexOf(name2));
    indeces.sort();
    values[indeces[0]][indeces[1]] = value;
  }

  // void addLink(String name1, String name2, T value) {
  //   int firstIndex = -1;
  //   int secondIndex = -1;
  //   for (int i = 0; i < names.length; i++) {
  //     if (names[i] == name1) {
  //       firstIndex = i;
  //     }
  //     if (names[i] == name2) {
  //       secondIndex = i;
  //     }
  //     if (firstIndex != -1 && secondIndex != -1) {
  //       break;
  //     }
  //   }
  //   if (firstIndex == -1) {
  //     names.add(name1);
  //     firstIndex = names.length - 1;
  //   }
  //   if (secondIndex == -1) {
  //     names.add(name2);
  //     secondIndex = names.length - 1;
  //   }
  //   if (firstIndex < secondIndex) {
  //     values[firstIndex][secondIndex] = value;
  //   } else {
  //     values[secondIndex][firstIndex] = value;
  //   }
  // }


}