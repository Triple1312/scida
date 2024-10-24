

import 'dart:io';

import 'DFColumn.dart';


class DataFrame {

  List<DFColumn> _base = [];

  DataFrame.from_csv(String filepath, {bool hascolumnNames = true, seperator = ',', List<String> columnNames = const []}) {
    List<String> lines = File(filepath).readAsLinesSync();
    List<List<String>> words = lines.map((e) => e.split(seperator)).toList();
    if (columnNames.isEmpty) {
      columnNames = words[0];
    }
    for (int i = 0; i < words.length; i++) {
      _base.add(DFColumn<String>(columnNames[i], words.sublist(1).fold([], (prev, e) => prev..add(e[i]))));
    }
  }

  get shape => [_base.isEmpty? 0: _base[0].length, _base.length];

  get size => _base.isEmpty? 0: _base[0].length * _base.length;

  get columns => _base.map((e) => e.columnName).toList();



  List<List<int?>> asInt() => _base.map((e) => e.asInt()).toList();

  List<List<double?>> asDouble() => _base.map((e) => e.asDouble()).toList();

  List<List<bool?>> asBool() => _base.map((e) => e.asBool()).toList();

  List<List<String>> asString() => _base.map((e) => e.asString()).toList();

  List<List> asList() => _base.map((e) => e).toList();




}