import 'dart:collection';



/// written by chatgpt
/// todo test and stuff
/// does not work the way I want it to
/// todo make it work with dataframe
class Apriori {
  final List<Set<int>> transactions;
  final double minSupport;
  int _itemSetSize = 1;

  Apriori(this.transactions, this.minSupport);

  Set<Set<int>> findFrequentItemsets() {
    var currentFrequentItemsets = _findFrequentSingleItemsets();
    var totalFrequentItemsets = HashSet<Set<int>>.from(currentFrequentItemsets);

    while (currentFrequentItemsets.isNotEmpty) {
      _itemSetSize++;
      var candidateItemsets = _aprioriGen(currentFrequentItemsets);
      var frequentItemsets = _filterCandidatesBySupport(candidateItemsets);
      totalFrequentItemsets.addAll(frequentItemsets);
      currentFrequentItemsets = frequentItemsets;
    }

    return totalFrequentItemsets;
  }

  Set<Set<int>> _findFrequentSingleItemsets() {
    var itemCounts = HashMap<int, int>();

    for (var transaction in transactions) {
      for (var item in transaction) {
        itemCounts.update(item, (count) => count + 1, ifAbsent: () => 1);
      }
    }

    var frequentItemsets = HashSet<Set<int>>();
    var minSupportCount = (transactions.length * minSupport).ceil();

    itemCounts.forEach((item, count) {
      if (count >= minSupportCount) {
        frequentItemsets.add({item});
      }
    });

    return frequentItemsets;
  }

  Set<Set<int>> _aprioriGen(Set<Set<int>> frequentItemsets) {
    var candidateItemsets = HashSet<Set<int>>();

    for (var itemset1 in frequentItemsets) {
      for (var itemset2 in frequentItemsets) {
        var union = itemset1.union(itemset2);
        if (union.length == _itemSetSize) {
          var allSubsetsAreFrequent = union
              .every((item) => union.difference({item}).contains(frequentItemsets));
          if (allSubsetsAreFrequent) {
            candidateItemsets.add(union);
          }
        }
      }
    }

    return candidateItemsets;
  }

  Set<Set<int>> _filterCandidatesBySupport(Set<Set<int>> candidateItemsets) {
    var itemSetCount = HashMap<Set<int>, int>();

    for (var transaction in transactions) {
      for (var candidate in candidateItemsets) {
        if (candidate.intersection(transaction).length == _itemSetSize) {
          itemSetCount.update(candidate, (count) => count + 1, ifAbsent: () => 1);
        }
      }
    }

    var minSupportCount = (transactions.length * minSupport).ceil();
    return candidateItemsets
        .where((itemset) => itemSetCount[itemset]! >= minSupportCount)
        .toSet();
  }
}

